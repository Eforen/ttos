-- SmartMine API v0.41
-- Excavates specified coordinates and unloads at a destination
-- v0.41
-- - put last position check in seperate function for debugging purposes
-- - fixed bug with resuming to wrong location on even rows

-- # NOTE: The turtle does not store it's status, instead it is radioed to the server
-- # NOTE: There's currently no way to individually set docking and drop-off coordinates
-- instead the turtle's position upon activation is automatically used

os.loadAPI('UberMiner/lib/smartmove.lua')


-- version information
function version()
	print('SmartMine v0.41\n')
end


-- Foreman
local serverID = -1
-- Docking station
local dockx, docky, dockz, dockd = 0, 0, 0, 0
-- Drop off
local dropx, dropy, dropz, dropd = 0, 0, 0, 0
-- Mining location
local minex, miney, minez = 0, 0, 0
-- Mine contraints
local minew, minel, mined = 0, 0, 0
local volume, progress = 0, 0
local status = 0
-- Status aliases:
-- 0 - Halted
-- 1 - Established
-- 2 - In progress
-- 3 - Paused
-- 11 - Returning to drop
-- 12 - Returning to dock
-- 13 - Resuming work
-- 21 - In drop-off queue
-- 31 - Dropping off

function screen()
	local percentage = math.floor(progress/volume*100)
	local report = percentage .. '% (' .. progress .. '/' .. volume .. ')'
	term.clear()
	term.setCursorPos(1,1)
	print('This is Droid ID'..os.computerID())
	print('\nDroid position:')
	print('\t\tx: ',smartmove.getX())
	print('\t\ty: ',smartmove.getY())
	print('\t\tz: ',smartmove.getZ())
	print('\nProgress: ' .. report)
	rednet.send(serverID,report)
end

function update()
	screen()
end

local function establish()
	if mined < 5 then mined = 5 end		-- Don't dig deeper than 5 due to bedrock
	volume = minew*minel*(miney-mined)
	progress = 0
	turtle.select(1)
	status = 1
	update()
end

function assignDock(ix,iy,iz,id)
	dockx = ix
	docky = iy
	dockz = iz
	dockd = id
end

function assignDrop(ix,iy,iz,id)
	dropx = ix
	dropy = iy
	dropz = iz
	dropd = id
end

local function assignMine(ix,iy,iz,iw,il,id)
	minex = ix
	miney = iy
	minez = iz
	minew = iw
	minel = il
	mined = id
	establish()
end

-- Check cargo bay
local function checkBay()
	if turtle.getItemCount(9) < 1 then return true
	else return false
	end
end

-- Establish last mined location
local function lastMine(inp)
	local target = inp+1
	local rx = 0
	local ry = 0
	local rz = 0
	
	-- calculate depth
	local levelSize = minew*minel
	local cDepth = math.floor(target/levelSize)
	-- calculate row
	local cRow = math.ceil((target-(cDepth*levelSize))/minew)
	-- calculate column
	local cCol = math.ceil((target-(cDepth*levelSize)-(minew*(cRow-1))))
	-- calculate coords
	if cRow%2 == 0 then
		-- calculate x backwards from end of mine
		rx = minex+minew-cCol
	else
		rx = minex+cCol-1
	end
	ry = miney-cDepth
	rz = minez+cRow-1
	
	-- DEBUG DATA
	local minedebug = 'levelSize '..levelSize..'\ncDepth '..cDepth..'\ncRow '..cRow..'\ncCol '..cCol..'\n'..rx..' '..ry..' '..rz
	print(minedebug)
	return cDepth, cRow, cCol, rx, ry, rz
end


-- Mining loop
local function excavate(continue)
	local rx = minex
	local ry = miney
	local rz = minez
	local cDepth = 0
	local cRow = 1
	local cCol = 1
	-- If digging was paused, go to last location
	if continue == 1 then
		rednet.send(serverID,'Resuming to ' .. progress)
		cDepth, cRow, cCol, rx, ry, rz = lastMine(progress)
	else rednet.send(serverID,'In progress')
	end
	
	-- move above starting location
	-- position above mine and break ground
	smartmove.moveTo(nil,dropy+2,nil,nil)
	smartmove.moveTo(rx,ry+1,rz,nil)
	turtle.digDown()
	progress=progress+1
	update()
	-- enter lane
	smartmove.down()
	
	-- Mining loop
	while progress<volume do
		-- whether to go +x or -x
		if cRow%2 == 1 then	-- +x
			local res = digLine(1)
			if res == 1 then
				cRow = cRow+1
			elseif res == 2 then
				cRow = 1
				cLevel = cDepth+1
			elseif res == 0 then
				returnToDrop()
				excavate(1)
				break
			elseif res == 3 then break
			end
		else				-- -x
			local res = digLine(-1)
			if res == 1 then
				cRow = cRow+1
			elseif res == 2 then
				cRow = 1
				cLevel = cDepth+1
			elseif res == 0 then
				returnToDrop()
				excavate(1)
				break
			elseif res == 3 then break
			end
		end
	end
end

function returnToDrop()
	rednet.send(serverID,'Dropping off')
	smartmove.moveTo(nil,miney+2,nil,nil)
	smartmove.moveTo(dropx,dropy+2,dropz,nil)
	smartmove.moveTo(dropx,dropy,dropz,dropd)
	local s = 1
	while s <= 9 do
		turtle.select(s)
		turtle.drop()
		s=s+1
	end
	turtle.select(1)
end

-- Return codes:
-- 0 - cargo bay full
-- 1 - reached end of lane, changed lane
-- 2 - reached end of level, change level
-- 3 - job completed
function digLine(direction)
	if direction == 1 then
		-- dig +x
		smartmove.face(3)
		while checkBay() and progress<volume do
			-- have we reached end of line
			if smartmove.getX() >= minex+minew-1 then
				-- change row
				if digTurn(-1) == 0 then return 1
				else return 2
				end
			else
				-- proceed digging
				turtle.dig()
				progress=progress+1
				update()
				local tries = 0
				while smartmove.forward() ~= true do if tries > 0 then rednet.send(serverID,'/!\\OBSTRUCTION/!\\') end tries=tries+1 end
			end
		end
		if progress >= volume then return 3
		else return 0 end
	elseif direction == -1 then
		-- dig -x
		smartmove.face(1)
		while checkBay() and progress<volume do
			-- have we reached end of line
			if smartmove.getX() <= minex then
				-- change row
				if digTurn(1) == 0 then return 1
				else return 2
				end
			else
				-- proceed digging
				turtle.dig()
				progress=progress+1
				update()
				local tries = 0
				while smartmove.forward() ~= true do if tries > 0 then rednet.send(serverID,'/!\\OBSTRUCTION/!\\') end tries=tries+1 end
			end
		end
		if progress >= volume then return 3
		else return 0 end
	end
end

-- Return codes:
-- 0 - changed lane, proceed digging
-- 1 - changed level, start new lane
function digTurn(direction)
	-- have we reached the end of level
	if smartmove.getZ() == (minez+minel-1) then
		-- return to x,z and descned
		smartmove.moveTo(minex,nil,minez,3)
		turtle.digDown()
		proress = progress+1
		update()
		smartmove.down()
		return 1
	end
	if direction == 1 then
		-- turn towards +x
		smartmove.face(0)
		turtle.dig()
		progress=progress+1
		update()
		local tries = 0
		while smartmove.forward() ~= true do if tries > 0 then rednet.send(serverID,'/!\\OBSTRUCTION/!\\') end tries=tries+1 end
		smartmove.face(3)
		return 0
	elseif direction == -1 then
		-- turn towards -x
		smartmove.face(0)
		turtle.dig()
		progress=progress+1
		update()
		local tries = 0
		while smartmove.forward() ~= true do if tries > 0 then rednet.send(serverID,'/!\\OBSTRUCTION/!\\') end tries=tries+1 end
		smartmove.face(1)
		return 0
	end
end


-- Remote set functions
function setX(inv)
	minex = inv
end

function setY(inv)
	miney = inv
end

function setZ(inv)
	minez = inv
end

function setW(inv)
	minew = inv
end

function setL(inv)
	minel = inv
end

function setD(inv)
	mined = inv
end

function setServer(inv)
	serverID = inv
end

function setForeman(inv)
	serverID = inv
	assignDock(smartmove.getX(),smartmove.getY(),smartmove.getZ(),smartmove.getDir())
	assignDrop(smartmove.getX(),smartmove.getY(),smartmove.getZ(),smartmove.getDir())
	establish()
	excavate()
	returnToDrop()
	rednet.send(serverID,'Idle/Finished')
end