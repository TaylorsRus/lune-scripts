local constants = require("../constants")
local execute = require("../modules/execute")

local function sync_asphalt(destination: "studio" | "cloud")
	execute({ "asphalt", "sync", "--target", destination }, constants.EXEC_OPTIONS)
end

return sync_asphalt
