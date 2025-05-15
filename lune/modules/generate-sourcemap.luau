local constants = require("../constants")
local execute = require("../modules/execute")

local function generate_sourcemap()
	execute({ "rojo", "sourcemap", "--output", constants.SOURCEMAP, "--include-non-scripts", constants.PROJECT }, constants.EXEC_OPTIONS)
end

return generate_sourcemap
