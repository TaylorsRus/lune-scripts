local fs = require("@lune/fs")

local isDir, readDir, removeFile = fs.isDir, fs.readDir, fs.removeFile

local function delete_meta_jsons(path: string)
	local parent = path:match("^(.*)/[^/]*$") or path
	local directory = readDir(parent)

	for _, file in directory do
		local name = file:match("^(.-)%.meta%.json$")
		if not name then continue end

		local associatedScripts = {
			Client = name .. ".client.luau",
			Server = name .. ".server.luau",
		}
		local isAssociatedWithScript = table.find(directory, associatedScripts.Client) or table.find(directory, associatedScripts.Server)
		if isAssociatedWithScript then removeFile(parent .. "/" .. file) end
	end
end

local function clean_metadata(directory: string)
	for _, file in readDir(directory) do
		local path = directory .. "/" .. file
		if isDir(path) then
			clean_metadata(path)
		else
			delete_meta_jsons(path)
		end
	end
end

return clean_metadata
