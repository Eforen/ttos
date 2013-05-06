function printStandardHeader(headerText)
	term.clear()
	print(headerText)
end

function standardConfermaion()
	--local waitingConfermation = true
	--while waitingConfermation == true do
	while true do
		event, param1, param2 = os.pullEvent("char")
		if param1 == "y" then
			-- waitingConfermation = false
			return true
		elseif param1 == "n" then
			-- waitingConfermation = false
			return false
		end
	end
end

function getTurtlePos( header )
	local posX, posY, posZ = gps.locate(1, false)
	local isGPS = false
	if posX ~= nil then
		if header ~= nil then printStandardHeader(header) end
		print("Is this turtle at X=" .. tostring(posX) .. " Y=" .. tostring(posY) .. " Z=" .. tostring(posZ) .. " (Y/N)?")
		isGPS = standardConfermaion()
	end

	posX, posY, posZ = smartmove.getX(), smartmove.getY(), smartmove.getZ()
	if posX ~= nil then
		if header ~= nil then printStandardHeader(header) end
		print("Is this turtle at X=" .. tostring(posX) .. " Y=" .. tostring(posY) .. " Z=" .. tostring(posZ) .. " (Y/N)?")
		isGPS = standardConfermaion()
	end

	if isGPS == false then
		if header ~= nil then printStandardHeader(header) end
		write("What is the X pos of this turtle: ")
		posX = tonumber(read())
		if header ~= nil then printStandardHeader(header) end
		write("What is the Y pos of this turtle: ")
		posY = tonumber(read())
		if header ~= nil then printStandardHeader(header) end
		write("What is the Z pos of this turtle: ")
		posZ = tonumber(read())
	end

	local dir = smartmove.getDir()
	isGPS = false --Reuse isGPS
	if posX ~= nil then
		if header ~= nil then printStandardHeader(header) end
		print("What is this turtles f direction?")
		print("2: North")
		print("3: East")
		print("0: South")
		print("1: West")
		print("Is faceing F=" .. tostring(dir) .. " (Y/N)?")
		isGPS = standardConfermaion() --Reuse isGPS
	end

	if isGPS == false then
		if header ~= nil then printStandardHeader(header) end
		print("What is this turtles f direction?")
		print("2: North")
		print("3: East")
		print("0: South")
		print("1: West")
		write("Enter the correct f#: ")
		dir = tonumber(read())
	end

	if header ~= nil then printStandardHeader(header) end
	print("Is X=" .. tostring(posX) .. " Y=" .. tostring(posY) .. " Z=" .. tostring(posZ) .. " F=" .. tostring(dir) .. " correct (Y/N)?")
	isGPS = standardConfermaion() --Reuse isGPS for confermation

	if isGPS == false then return getTurtlePos(header) end

	return posX, posY, posZ, dir
end

function getInput( default )
	result = read()
	if result == "" or result == nil or result == "\n" or result == "\r" or result == " " then
		if default ~= nil then return default
		else return ""
		end
	else return result
	end
end