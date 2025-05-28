local execute = require("./modules/execute")

execute(
	"Invoke-RestMethod https://raw.githubusercontent.com/rojo-rbx/rokit/main/scripts/install.ps1 | Invoke-Expression"
)
execute("rokit add lune-org/lune@0.9.3")
execute("rokit add Upliftgames/rojo@7.5.1-uplift.syncback.rc.21")
execute("rokit install")

return nil
