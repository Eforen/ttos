--Networking
sOpenedSide = nil

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function open()
	local bOpen, sFreeSide = false, nil
	for n,sSide in pairs(rs.getSides()) do	
		if peripheral.getType( sSide ) == "modem" then
			sFreeSide = sSide
			if rednet.isOpen( sSide ) then
				bOpen = true
				break
			end
		end
	end
	
	if not bOpen then
		if sFreeSide then
			print( "No modem active. Opening "..sFreeSide.." modem" )
			rednet.open( sFreeSide )
			sOpenedSide = sFreeSide
			return true
		else
			print( "No modem attached" )
			return false
		end
	end
	return true
end

function close()
	if sOpenedSide then
		rednet.close( sOpenedSide )
	end
end

function broadcastAlive()
	--rednet.br
end

-- End of networking

--Start of movement
fuelSlot = 16

function checkFuel()
	write("Debug: checkFuel(); \n")
	if (turtle.getFuelLevel()<=0) then
		write("Debug: refueling... \n")
		turtle.select(fuelSlot)
		turtle.refuel(1)
	end
end

function f()
	--if not turtle.detect() then turtle.forward() end
	if not turtle.forward() then
		write("Failed Move Forward")
		checkFuel()
		while not turtle.forward() do
			write("Failed Move Forward Agean Sleeping")
			sleep(1)
		end
	end
end
function b()
	if not turtle.back() then
		write("Failed Move Back")
		checkFuel()
		while not turtle.back() do
			write("Failed Move Back Agean Sleeping")
			sleep(1)
		end
	end
end
function l()
	tl()
	f()
	tr()
	--turtle.left()
end
function r()
	tr()
	f()
	tl()
	--turtle.right()
end
function u()
	--if not turtle.detectUp() then turtle.up() end
	--turtle.up()
	if not turtle.up() then
		checkFuel()
		write("Failed Move Up")
		while not turtle.up() do
			write("Failed Move Up Agean Sleeping")
			sleep(1)
		end
	end
end
function d()
	--if not turtle.detectDown() then turtle.down() end
	--turtle.down()
	if not turtle.down() then
		checkFuel()
		write("Failed Move Down")
		while not turtle.down() do
			write("Failed Move Down Agean Sleeping")
			sleep(1)
		end
	end
end

function tl()
	turtle.turnLeft()
end
function tr()
	turtle.turnRight()
end
function ta()
	turtle.turnRight()
	turtle.turnRight()
end

function dig()
	while turtle.detect() do
		turtle.dig()
		sleep(1)
	end
end
function digUp()
	while turtle.detectUp() do
		turtle.digUp()
		sleep(1)
	end
end
function digDown()
	while turtle.detectDown() do
		turtle.digDown()
		sleep(1)
	end
end
function digAll()
	dig()
	digUp()
	digDown()
end
function digBoth()
	digUp()
	digDown()
end
function p( slot )
	turtle.select(slot)
	turtle.place()
end
function pu( slot )
	turtle.select(slot)
	turtle.placeUp()
end
function pd( slot )
	turtle.select(slot)
	turtle.placeDown()
end