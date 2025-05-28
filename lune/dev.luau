local sync_assets = require("./modules/sync-assets")
local constants = require("./constants")
local execute = require("./modules/execute")
local build_project = require("./modules/build-project")
local sync_project = require("./modules/sync-project")
local update_packages = require("./modules/update-packages")

local EXEC_OPTIONS = constants.EXEC_OPTIONS
local GAME = constants.GAME

local function invoke_rbxl()
	execute({ "Invoke-Item", GAME }, EXEC_OPTIONS)
end

update_packages()
sync_assets("studio")
build_project()
invoke_rbxl()
sync_project()
