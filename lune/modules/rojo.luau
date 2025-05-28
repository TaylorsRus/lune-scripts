local execute = require("./execute")
local config = require("../config")

local GAME = config.GAME
local PROJECT = config.PROJECT
local EXEC_OPTIONS = config.EXEC_OPTIONS

local rojo = {}

function rojo.build(data: { watch: boolean? }?)
	local watch = if data and data.watch then data.watch else false

	execute({ "rojo", "build", "--output", GAME, if watch then "--watch" else "" }, EXEC_OPTIONS)
end

function rojo.serve()
	execute({ "rojo", "serve", PROJECT }, EXEC_OPTIONS)
end

return rojo
