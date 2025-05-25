local constants = require("../constants")
local execute = require("../modules/execute")

local function build_rbxl(watch: boolean?)
	execute({ "rojo", "build", "--output", constants.GAME, if watch then "--watch" else "" }, constants.EXEC_OPTIONS)
end

return build_rbxl
