local constants = require("../constants")
local execute = require("../modules/execute")

local function asphalt_sync(destination: "studio" | "cloud")
	execute({ "asphalt", "sync", "--target", destination }, constants.EXEC_OPTIONS)
end

return asphalt_sync
