local execute = require("./modules/execute")

execute(
	"Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression"
)
execute("rokit add lune-org/lune@0.9.3")

return nil
