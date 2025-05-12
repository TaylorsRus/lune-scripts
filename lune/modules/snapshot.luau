local fs = require("@lune/fs")

type File = { path: string, timestamp: number? }
export type Snapshot = { [string]: File | Snapshot }

local isDir, readDir = fs.isDir, fs.readDir

local snapshot = {}

local function isFile(table)
	return if table.path then true else false
end

function snapshot.capture(path: string): Snapshot
	local table: Snapshot = {}

	for _, entry in readDir(path) do
		local fullPath = path .. "/" .. entry

		local metadata = fs.metadata(fullPath)
		table[entry] = if isDir(fullPath)
			then snapshot.capture(fullPath)
			else {
				path = fullPath,
				timestamp = if metadata.modifiedAt then metadata.modifiedAt.unixTimestampMillis else nil,
				kind = metadata.kind or nil,
			} :: File
	end

	return table
end

function snapshot.has_changed(old: Snapshot, new: Snapshot): boolean
	for key, oldEntry in old do
		local newEntry = new[key]

		local deleted = newEntry == nil
		if deleted then
			return true
		end

		if isFile(oldEntry) and isFile(newEntry) then
			local oldFile = oldEntry :: File
			local newFile = newEntry :: File

			local differentFile = oldFile.path ~= newFile.path
			if differentFile then
				return true
			end

			local oldFileModifiedAt, newFileModifiedAt = oldFile.timestamp, newFile.timestamp
			if (oldFileModifiedAt and newFileModifiedAt) and newFileModifiedAt > oldFileModifiedAt then
				return true
			end
		elseif not isFile(oldEntry) and not isFile(newEntry) then
			if snapshot.has_changed(oldEntry :: Snapshot, newEntry :: Snapshot) then
				return true
			end
		end
	end

	for key in new do
		if old[key] == nil then
			return true
		end
	end

	return false
end

return snapshot
