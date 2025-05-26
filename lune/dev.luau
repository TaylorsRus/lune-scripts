local constants = require("./constants")
local execute = require("./modules/execute")
local sync_asphalt = require("./modules/sync-asphalt")
local sync_project = require("./modules/sync-project")
local update_wally = require("./modules/update-wally")

local EXEC_OPTIONS = constants.EXEC_OPTIONS
local GAME = constants.GAME

local function invoke_rbxl()
	execute({ "Invoke-Item", GAME }, EXEC_OPTIONS)
end

update_wally()
sync_asphalt("studio")
invoke_rbxl()
sync_project()
