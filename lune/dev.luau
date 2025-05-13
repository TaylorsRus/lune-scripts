local build_rbxl = require("./modules/build-rbxl")
local constants = require("./constants")
local execute = require("./modules/execute")
local sync_project = require("./modules/sync-project")
local update_wally = require("./modules/update-wally")

local EXEC_OPTIONS = constants.EXEC_OPTIONS
local RBXL = "dev.rbxl"

local function sync_asphalt()
	execute({ "asphalt", "sync", "--target", "studio" }, EXEC_OPTIONS)
end

local function invoke_rbxl()
	execute({ "Invoke-Item", RBXL }, EXEC_OPTIONS)
end

update_wally()
sync_asphalt()
build_rbxl()
invoke_rbxl()
sync_project()
