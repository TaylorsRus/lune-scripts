local constants = require("../constants")
local execute = require("../modules/execute")
local generate_sourcemap = require("./generate-sourcemap")

local function build_rbxl()
	execute({ "rojo", "build", "--output", constants.RBXL }, constants.EXEC_OPTIONS)
	generate_sourcemap()
end

return build_rbxl
