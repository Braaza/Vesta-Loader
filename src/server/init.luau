local Controller, proxy, methods = {}, {}, {}

function methods.__index(_, index)
	local self = Controller
	if self[index] then return self[index] end
	if not self.Find or typeof(self.Find) ~= "function" then return end
	return self:Find(index)
end

function Controller:Run(module: string, functionStart: string, ...)
	if not self.debug(proxy[module] and proxy[module][functionStart] and typeof(proxy[module][functionStart]) == "function", `Loading expected, got {module}`) then return end
	task.spawn(proxy[module][functionStart], proxy[module], ...)
end

function Controller:OnServer()
	self:Run("ModuleName", "ModuleFunction")
end

function Controller:Find(value, ...)
	local modules = self.CollectionService:GetTagged("Module")
	for _, module: ModuleScript in modules or {} do 
		if module.Name ~= value then continue end
		return self:RequireModule(module)
	end
	return self.debug(nil, `Not results in search...`)
end

function Controller:RequireModule(module: ModuleScript, ...)
	if not self.debug(module and typeof(module) == "Instance" and module:IsA("ModuleScript"), `ModuleScript expected, got {module}`) then return end

	local sucess, returned = pcall(require, module)
	if not self.debug(sucess, returned) then return end

	self[module.Name] = returned
	setmetatable(returned, {__index = proxy})
	self.debug:Log('INFO', `Loaded Successfully!`, module)
	return returned
end

function Controller:OnInit()
	if not self.RunService:IsServer() then return end
	self:OnServer()
end

do --TODO: UTILS IN CONTROLLER
	setmetatable(proxy, methods)

	Controller.configs = require("@self/configs") or {} :: {}
	Controller.cache = require("@self/cache") or {} :: {}
	Controller.debug = require("@self/debug") or {} :: {}
	
	Controller.ProximityPromptService = game:GetService("ProximityPromptService") :: ProximityPromptService
	Controller.ServerScriptServices = game:GetService("ServerScriptService") :: ServerScriptService
	Controller.ReplicatedStorage = game:GetService("ReplicatedStorage") :: RobloxReplicatedStorage
	Controller.CollectionService = game:GetService("CollectionService") :: CollectionService
	Controller.UserInputService = game:GetService("UserInputService") :: UserInputService
	Controller.TeleportService = game:GetService("TeleportService") :: TeleportService
	Controller.ServerStorage = game:GetService("ServerStorage") :: ServerStorage
	Controller.TweenService = game:GetService("TweenService") :: TweenService
	Controller.RunService = game:GetService("RunService") :: RunService
	Controller.Players = game:GetService("Players") :: Players
end

return Controller