local config = require("../config")
local execute = require("../modules/execute")

local function generate_sourcemap(watch: boolean?)
	execute({
		"rojo",
		"sourcemap",
		"--output",
		config.SOURCEMAP,
		"--include-non-scripts",
		config.PROJECT,
		if watch then "--watch" else "",
	}, config.EXEC_OPTIONS)
end

return generate_sourcemap
