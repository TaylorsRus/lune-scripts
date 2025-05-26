local constants = require("../constants")
local execute = require("../modules/execute")

local function rojo_build(watch: boolean?)
	execute({ "rojo", "build", "--output", constants.GAME, if watch then "--watch" else "" }, constants.EXEC_OPTIONS)
end

return rojo_build
