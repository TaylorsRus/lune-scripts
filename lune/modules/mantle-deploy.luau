local constants = require("../constants")
local execute = require("./execute")

export type Environment = "dev" | "uat" | "prod"

local function mantle_deploy(environment: Environment)
	execute({ "mantle", "deploy", "--environment", environment }, constants.EXEC_OPTIONS)
end

return mantle_deploy
