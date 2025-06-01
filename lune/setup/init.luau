local fs = require("@lune/fs")
local serde = require("@lune/serde")

local execute = require("../modules/execute") :: any --https://github.com/JohnnyMorganz/luau-lsp/issues/1081
local asphalt = require("../modules/asphalt") :: any --https://github.com/JohnnyMorganz/luau-lsp/issues/1081

local TOOL_ASSOCIATIONS = {
	rojo = "Upliftgames/rojo@7.5.1-uplift.syncback.rc.21",
	lune = "lune-org/lune@0.9.3",
	asphalt = "jackTabsCode/asphalt@1.0.0-pre.9",
}

local function exhausts(value: never)
	return error(`{value} not exhausted.`)
end

execute("Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression")

if not fs.isFile("rokit.toml") then
	execute("rokit init")
end
local data = serde.decode("toml", fs.readFile("rokit.toml"))
local tools = data.tools

local function add_tool(tool: "rojo" | "lune" | "asphalt")
	if tools and not tools[tool] then
		local tool = if tool == "rojo"
			then TOOL_ASSOCIATIONS.rojo
			elseif tool == "lune" then TOOL_ASSOCIATIONS.lune
			elseif tool == "asphalt" then TOOL_ASSOCIATIONS.asphalt
			else exhausts(tool)

		execute(`rokit add {tool}`)
	end
end

add_tool("lune")
add_tool("rojo")
add_tool("asphalt")
execute("rokit install")

asphalt.init()

return nil
