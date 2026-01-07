local module = {}

module.A = 100
module.B = function(self, ...)
	return 200
end

function module:GetValue(requestValue: any, ...)
	if not self.debug(requestValue, `Value expected, got {requestValue}.`) then return end
	return self[requestValue]
end

return module