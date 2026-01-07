local debug, methods = {}, {}

function methods.__call(self, expected, debugMessage: string, levelType)
	if expected then return expected end
	if debugMessage then self:Log(levelType, debugMessage, expected) end
	return expected
end

function debug:Log(levelType: string, debugMessage: string, prefix: any)
	local levelMessage = self.Levels[levelType] or 1
	if levelMessage < self.CurrentLevel then return end

	levelType = self.LogFormats[levelType] and levelType or "UNKNOWN"
	prefix = prefix and `[🟣 {prefix}]` or ``
	local arg = `{prefix}{self.LogFormats[levelType]}`
	local logMessage = `{debugMessage}`

	if self.Levels[levelType] == 1 then
		print(arg, logMessage)
	elseif self.Levels[levelType] == 2 then
		print(arg, logMessage)
	elseif self.Levels[levelType] == 3 then
		warn(arg, logMessage)
	elseif self.Levels[levelType] == 4 then
		error(arg, logMessage)
	else
		warn(prefix, logMessage)
	end
	return
end

do
	debug.LogFormats = {
		["UNKNOWN"] = `[⚫ UNKNOWN] :`,
		["DEBUG"] = `[🟢 DEBUG] :`,
		["ERROR"] = `[🔴 ERROR] :`,
		["INFO"] = `[🔵 INFO] :`,
		["WARN"] = `[🟠 WARN] :`,
		["TEST"] = `[🟤 TEST] :`,
	}
	debug.Levels = {
		["TEST"] = 0,
		["DEBUG"] = 1,
		["INFO"] = 2,
		["WARN"] = 3,
		["ERROR"] = 4,
}
	debug.CurrentLevel = debug.Levels.INFO
	setmetatable(debug, methods)
end

return debug