local datetime = require("@lune/datetime")
local fs = require("@lune/fs")
local task = require("@lune/task")

local clean_metadata = require("./clean-metadata")
local constants = require("../constants")
local exception_list = require("../constants/exception-list")
local execute = require("./execute")
local generate_sourcemap = require("./generate-sourcemap")
local rojo_build = require("./rojo-build")
local snapshot = require("./snapshot")

local isDir, readDir, writeDir, removeDir = fs.isDir, fs.readDir, fs.writeDir, fs.removeDir
local isFile, readFile, writeFile = fs.isFile, fs.readFile, fs.writeFile

local PROJECT = constants.PROJECT
local EXEC_OPTIONS = constants.EXEC_OPTIONS
local SRC = constants.SRC
local GAME = constants.GAME

local SYNC_INTERVAL = 0.5
local DIST = "dist"

local function should_compile_dist_directory()
	return if table.find(exception_list, "--no-dist") == nil then true else false
end

local function get_modified_at()
	local metadata = fs.metadata(GAME)
	return metadata.modifiedAt
end

local function copy_rbxm_files_to_dist()
	if not isDir(DIST) then writeDir(DIST) end

	local function find_and_copy_rbxm(directory: string)
		for _, item in readDir(directory) do
			local path = directory .. "/" .. item

			if isFile(path) and path:match("%.rbxm$") then
				local relativePath = path:sub(#SRC + 2)
				local distPath = DIST .. "/" .. relativePath

				local destinationDirectory = distPath:match("(.*/)") or ""
				if destinationDirectory ~= "" and not isDir(destinationDirectory) then writeDir(destinationDirectory) end
				writeFile(distPath, readFile(path))
			elseif isDir(path) then
				find_and_copy_rbxm(path)
			end
		end
	end
	find_and_copy_rbxm(SRC)
end

local function syncback_rojo()
	execute({ "rojo", "syncback", "--input", GAME, "--non-interactive", PROJECT }, EXEC_OPTIONS)
end

local function serve_rojo()
	local function create_build_project()
		local path = "build.project.json"
		local defaultContent = readFile(PROJECT)
		local modifiedContent = defaultContent:gsub(SRC, DIST)
		writeFile(path, modifiedContent)
		return path
	end

	local buildProject = if should_compile_dist_directory() then create_build_project() else PROJECT
	print(buildProject)
	execute({ "rojo", "serve", buildProject }, EXEC_OPTIONS)
end

local function compile_dist()
	execute({ "darklua", "process", SRC, DIST }, EXEC_OPTIONS)
	copy_rbxm_files_to_dist()
end

local function sync_project()
	local shouldCompileDistDirectory = should_compile_dist_directory()
	if shouldCompileDistDirectory then
		compile_dist()
	elseif isDir(DIST) then
		removeDir(DIST)
	end
	task.defer(function()
		generate_sourcemap(true)
	end)
	task.defer(function()
		rojo_build(true)
	end)
	task.defer(serve_rojo)

	local lastSave = datetime.now()
	local lastSourceSnapshot = snapshot.capture(constants.SRC)
	while true do
		local modifiedAt = get_modified_at()
		if modifiedAt and modifiedAt.unixTimestamp > lastSave.unixTimestamp then
			lastSave = modifiedAt

			syncback_rojo()
			clean_metadata(SRC)
		end

		if not shouldCompileDistDirectory then continue end
		local sourceSnapshot = snapshot.capture(constants.SRC)
		if snapshot.has_changed(lastSourceSnapshot, sourceSnapshot) then
			compile_dist()
			lastSourceSnapshot = sourceSnapshot
		end
		task.wait(SYNC_INTERVAL)
	end
end

return sync_project
