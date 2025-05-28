local process = require("@lune/process")

local asphalt_sync = require("./modules/asphalt-sync")
local mantle_deploy = require("./modules/mantle-deploy")
local build_project = require("./modules/build-project")

type Environment = mantle_deploy.Environment

local args = process.args
local environment: Environment = nil
for _, arg: Environment in args do
	if arg == "dev" or arg == "uat" or arg == "prod" then
		environment = arg
		break
	end
end

if environment == nil then
	error("Must pass environment: 'dev' | 'uat' | 'prod'")
end

asphalt_sync("cloud")
build_project()
mantle_deploy(environment)
asphalt_sync("studio")
