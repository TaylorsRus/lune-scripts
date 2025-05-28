local fs = require("@lune/fs")
local serde = require("@lune/serde")

local execute = require("./modules/execute")

local TOOL_ASSOCIATIONS = {
	rojo = "Upliftgames/rojo@7.5.1-uplift.syncback.rc.21",
	lune = "lune-org/lune@0.9.3",
}

local function exhausts(value: never)
	return error(`{value} not exhausted.`)
end

execute(
	"Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression"
)

if not fs.isFile("rokit.toml") then
	execute("rokit init")
end
local data = serde.decode("toml", fs.readFile("rokit.toml"))
local tools = data.tools

local function add_tool(tool: "rojo" | "lune")
	if tools and not tools[tool] then
		local tool = if tool == "rojo"
			then TOOL_ASSOCIATIONS.rojo
			elseif tool == "lune" then TOOL_ASSOCIATIONS.lune
			else exhausts(tool)

		execute(`rokit add {tool}`)
	end
end

add_tool("lune")
add_tool("rojo")
execute("rokit install")

execute("")

return nil
