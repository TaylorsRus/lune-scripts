local process = require("@lune/process")
local args = process.args

local exceptionList: { "--no-dist" } = {}
for _, exception in args do
	table.insert(exceptionList, exception)
end

return exceptionList
