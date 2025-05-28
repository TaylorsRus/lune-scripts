local execute = require("./modules/execute")

execute(
	"Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression"
)

return nil
