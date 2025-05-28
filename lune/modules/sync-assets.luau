local config = require("../config")
local execute = require("../modules/execute")

local function sync_assets(destination: "studio" | "cloud")
	execute(`asphalt sync --target {destination}`, config.EXEC_OPTIONS)
end

return sync_assets
