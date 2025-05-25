local constants = require("../constants")
local execute = require("../modules/execute")

local function generate_sourcemap(watch: boolean?)
	execute(
		{ "rojo", "sourcemap", "--output", constants.SOURCEMAP, "--include-non-scripts", constants.PROJECT, if watch then "--watch" else "" },
		constants.EXEC_OPTIONS
	)
end

return generate_sourcemap
