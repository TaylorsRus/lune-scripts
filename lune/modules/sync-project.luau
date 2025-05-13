local datetime = require("@lune/datetime")
local fs = require("@lune/fs")
local task = require("@lune/task")

local clean_metadata = require("./clean-metadata")
local constants = require("../constants")
local execute = require("./execute")
local snapshot = require("./snapshot")

local isDir, readDir, writeDir = fs.isDir, fs.readDir, fs.writeDir
local isFile, readFile, writeFile = fs.isFile, fs.readFile, fs.writeFile

local PROJECT_CONFIG = constants.PROJECT_CONFIG
local EXEC_OPTIONS = constants.EXEC_OPTIONS
local SRC = constants.SRC

local SYNC_INTERVAL = 0.5
local DIST = "dist"

local function get_modified_at()
	local metadata = fs.metadata("dev.rbxl")
	return metadata.modifiedAt
end

local function copy_rbxm_files_to_dist()
	if not isDir(DIST) then
		writeDir(DIST)
	end

	local function find_and_copy_rbxm(directory: string)
		for _, item in readDir(directory) do
			local path = directory .. "/" .. item

			if isFile(path) and path:match("%.rbxm$") then
				local relativePath = path:sub(#SRC + 2)
				local distPath = DIST .. "/" .. relativePath

				local destinationDirectory = distPath:match("(.*/)") or ""
				if destinationDirectory ~= "" and not isDir(destinationDirectory) then
					writeDir(destinationDirectory)
				end
				writeFile(distPath, readFile(path))
			elseif isDir(path) then
				find_and_copy_rbxm(path)
			end
		end
	end
	find_and_copy_rbxm(SRC)
end

local function syncback_rojo()
	execute({ "rojo", "syncback", "--input", "dev.rbxl", "--non-interactive", PROJECT_CONFIG }, EXEC_OPTIONS)
end

local function serve_rojo()
	local function create_build_project()
		local defaultContent = readFile(PROJECT_CONFIG)
		local modifiedContent = defaultContent:gsub(SRC, DIST)
		local buildProject = writeFile("build.project.json", modifiedContent)
		return buildProject
	end

	local buildProject = create_build_project()
	execute({ "rojo", "serve", buildProject }, EXEC_OPTIONS)
end

local function compile_dist()
	execute({ "darklua", "process", SRC, DIST }, EXEC_OPTIONS)
	copy_rbxm_files_to_dist()
end

local function watch_rbxl()
	compile_dist()
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

		local sourceSnapshot = snapshot.capture(constants.SRC)
		if snapshot.has_changed(lastSourceSnapshot, sourceSnapshot) then
			compile_dist()
			lastSourceSnapshot = sourceSnapshot
		end
		task.wait(SYNC_INTERVAL)
	end
end

return watch_rbxl
