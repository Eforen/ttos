local typeInfo = 1
local typeWarning = 2
local typeError = 3

local logServerID = 0

function setNetID( netID )
	-- body
	logServerID=id
end

function log( typeID, msg )
	write("Log: ")
	if typeID == typeInfo then
		write("-Info- ")
	elseif typeID == typeWarning then
		write("-Warning- ")
	elseif typeID == typeError then
		write("-Error- ")
	end
	write(msg)
end