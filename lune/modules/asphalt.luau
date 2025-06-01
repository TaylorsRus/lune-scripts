local asphalt = {}

local stdio = require("@lune/stdio")
local serde = require("@lune/serde")
local fs = require("@lune/fs")

type Creator = "group" | "user"
type CodegenStyle = "nested" | "flat"
type CodegenLanguage = "luau" | "typescript"
type Config = {
	["creator"]: {
		type: Creator,
		id: number,
	},
	["codegen"]: {
		typescript: boolean,
		style: CodegenStyle,
	},
	["inputs.asphalt"]: {
		path: string,
		output_path: string,
	},
}

local LANGUAGE_OPTIONS = {
	"typescript",
	"luau",
}

function asphalt.init()
	local data: Config = {
		["creator"] = {
			type = "user",
			id = 0,
		},
		["codegen"] = {
			typescript = false,
			style = "nested",
		},
		[`inputs.asphalt`] = {
			path = "",
			output_path = "",
		},
	}

	local creator = data["creator"]
	creator["type"] = stdio.prompt("select", "Upload to cloud under user or group?", { "user", "group" })
	creator["id"] = (function()
		local value = nil
		while value == nil do
			local string = stdio.prompt("text", "Cloud target id:")
			local number = tonumber(string)
			if number == nil then
				print("Please pass a valid (number) id.")
			else
				value = number
			end
		end
		return value
	end)()

	local codegen = data["codegen"]
	codegen["typescript"] = LANGUAGE_OPTIONS[stdio.prompt("select", "Language for codegen?", LANGUAGE_OPTIONS)] == "typescript"
	codegen["style"] = stdio.prompt("select", "Style of codegen?", { "nested", "flat" })

	local inputsAsphalt = data["inputs.asphalt"]
	inputsAsphalt["path"] = stdio.prompt("text", "Input path:")
	inputsAsphalt["output_path"] = stdio.prompt("text", "Output path:")

	stdio.write(stdio.color("yellow"))
	print(
		"WARNING, DUE TO A LUNE BUG, YOU WILL HAVE TO MANUALLY STRIP THE SPEECH MARKS OFF OF THE inputs.asphalt ENTRY IN YOUR NEWLY GENERATED CONFIG FILE."
	)
	print("WARNING, THIS SCRIPT DOES NOT CURRENTLY CHECK THAT THE PASSED INPUT AND OUTPUT DIRECTORIES EXIST. SELF-VALIDATE.")
	stdio.write(stdio.color("reset"))
	fs.writeFile("asphalt.toml", serde.encode("toml", data, true))
end

return asphalt
