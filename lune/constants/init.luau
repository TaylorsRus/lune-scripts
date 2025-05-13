local process = require("@lune/process")

local constants = {}

constants.EXEC_OPTIONS = { shell = true, stdio = "default" } :: process.ExecOptions
constants.SOURCEMAP = "sourcemap.json"
constants.PROJECT_CONFIG = "default.project.json"
constants.GAME = "game.rbxl"
constants.SRC = "src"

return constants
