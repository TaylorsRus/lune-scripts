local config = require("../config")
local execute = require("../modules/execute")

local function build_project(watch: boolean?)
	execute(`rojo build --output {config.GAME} {if watch then "--watch" else ""}`, config.EXEC_OPTIONS)
end

return build_project
