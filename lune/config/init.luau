local process = require("@lune/process")

local config = {}

config.EXEC_OPTIONS = { shell = true, stdio = "default" } :: process.ExecOptions
config.SOURCEMAP = "sourcemap.json"
config.PROJECT = "default.project.json"
config.GAME = "game.rbxl"
config.SRC = "src"

return config
