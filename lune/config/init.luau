local process = require("@lune/process")

local config = {}

config.EXCEPTION_LIST = (function()
	local args = process.args

	local exceptionList: { "--no-dist" } = {}
	for _, exception in args do
		table.insert(exceptionList, exception)
	end

	return exceptionList
end)()
config.EXEC_OPTIONS = { shell = true, stdio = "default" } :: process.ExecOptions
config.SOURCEMAP = "sourcemap.json"
config.PROJECT = "default.project.json"
config.GAME = "game.rbxl"
config.SRC = "src"

return config
