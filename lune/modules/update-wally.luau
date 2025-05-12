local constants = require("../constants")
local execute = require("../modules/execute")
local generate_sourcemap = require("./generate-sourcemap")

local EXEC_OPTIONS = constants.EXEC_OPTIONS

local SOURCEMAP = constants.SOURCEMAP

local function update_wally()
	execute({ "wally", "install" }, EXEC_OPTIONS)
	generate_sourcemap()
	execute({ "wally-package-types", "--sourcemap", SOURCEMAP, "Packages" }, EXEC_OPTIONS)
	generate_sourcemap()
end

return update_wally
