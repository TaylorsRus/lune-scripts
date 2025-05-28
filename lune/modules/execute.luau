local process = require("@lune/process")

type ExecOptions = process.ExecOptions

local function execute(command: string, options: ExecOptions?)
	local parts = {}
	for part in command:gmatch("%S+") do
		table.insert(parts, part)
	end

	local bin = parts[1]
	local args = {}
	for i = 2, #parts do
		table.insert(args, parts[i])
	end

	local options: ExecOptions = options and table.clone(options) or {}
	options.shell = if options.shell == nil or options.shell == true then true else nil

	local result = table.clone(process.exec(bin, args, options))
	if not result.ok then
		print(`Command failed:\n{result.stderr}\n{result.stdout}`)
	end
	return result
end

return execute
