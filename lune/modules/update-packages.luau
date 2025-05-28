local config = require("../config")
local execute = require("../modules/execute")
local generate_sourcemap = require("../modules/generate-sourcemap")

local EXEC_OPTIONS = config.EXEC_OPTIONS

local SOURCEMAP = config.SOURCEMAP

local function update_packages()
	execute({ "wally", "install" }, EXEC_OPTIONS)
	generate_sourcemap()
	execute({ "wally-package-types", "--sourcemap", SOURCEMAP, "Packages" }, EXEC_OPTIONS)
end

return update_packages
