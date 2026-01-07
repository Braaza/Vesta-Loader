local module = {}

function module:ModuleFunction()
	local returnValue = self.OtherModule:GetValue("B")
	
	warn(returnValue())
	warn(self.OtherModule.A)
end

return module