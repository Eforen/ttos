-- SmartMove API v0.35
-- This API will attempt to remember bot position and update it during movement
-- v0.35
-- - improved pathfinding alghorithm for circumventing complex obstacles
-- - fixed bug that caused the bot to try and pathfind when the destination has been reached with fewer tries than allowed
-- v0.3
-- - bot will not run into mobs and players
-- - some rudimentary pathfinding around obstacles will be preformed

-- # NOTE: Bot has problems avoiding obstacles above it that are wide.

--os.loadAPI('/TreeBot/lib/config')


-- Initialize coordinate globals
local xpos, ypos, zpos, dir = 0, 0, 0, 0

local function initCoords()
	if config.is('dir') then
		xpos=tonumber(config.get('xpos'))
		ypos=tonumber(config.get('ypos'))
		zpos=tonumber(config.get('zpos'))
		dir=tonumber(config.get('dir'))
	else
		config.new('xpos')
		config.new('ypos')
		config.new('zpos')
		config.new('dir')
		config.set('xpos', 0)
		config.set('ypos', 0)
		config.set('zpos', 0)
		config.set('dir', 0)
		xpos=0
		ypos=0
		zpos=0
		dir=0
	end
end

function setCoords(newx, newy, newz, newdir)
	xpos = newx
	ypos = newy
	zpos = newz
	dir = newdir
	config.set('xpos', xpos)
	config.set('ypos', ypos)
	config.set('zpos', zpos)
	config.set('dir', dir)
end

function getX()
	return xpos
end

function getY()
	return ypos
end

function getZ()
	return zpos
end

function getDir()
	return dir
end


-- Change individual coords
function setX(inx)
	print('Set X to ' .. inx)
	xpos = inx
	config.set('xpos', xpos)
end

function setY(iny)
	print('Set Y to ' .. iny)
	ypos = iny
	config.set('ypos', ypos)
end

function setZ(inz)
	print('Set Z to ' .. inz)
	zpos = inz
	config.set('zpos', zpos)
end

function setDir(ind)
	print('Set Dir to ' .. ind)
	dir = ind
	config.set('dir', dir)
end


-- Update location
local function update(to)
	if to == 'f' then
		-- moved forward
		if dir == 0 then
			zpos=zpos+1
			config.set('zpos',zpos)
		elseif dir == 1 then
			xpos=xpos-1
			config.set('xpos',xpos)
		elseif dir == 2 then
			zpos=zpos-1
			config.set('zpos',zpos)
		elseif dir == 3 then
			xpos=xpos+1
			config.set('xpos',xpos)
		end
	elseif to == 'u' then
		--moved up
		ypos=ypos+1
		config.set('ypos',ypos)
	elseif to == 'd' then
		--moved down
		ypos=ypos-1
		config.set('ypos',ypos)
	end
end


-- Align direction
function face (faceto)
	local dirdif = faceto-dir
	if dirdif == 1 then turtle.turnRight()
	elseif dirdif == -3 then turtle.turnRight()
	elseif dirdif == -1 then turtle.turnLeft()
	elseif dirdif == 3 then turtle.turnLeft()
	elseif dirdif == 2 then
		turtle.turnLeft()
		turtle.turnLeft()
	elseif dirdif == -2 then
		turtle.turnLeft()
		turtle.turnLeft()
	end
	config.set('dir',faceto)
	dir=faceto
end

-- Turn left
function left()
	dir=dir-1
	if dir < 0 then dir = 3 end
	turtle.turnLeft()
	config.set('dir',dir)
end

-- Turn right
function right()
	dir=dir+1
	if dir > 3 then dir = 0 end
	turtle.turnRight()
	config.set('dir',dir)
end


-- Basic move commands with obstruction scan
-- Second check failing means mob/player is in the way, but no diffirence in return value. May be implementd in future version
function forward()
	-- check for obstructions
	if turtle.detect() then
		return false
	elseif turtle.forward() then
		-- update position
		update('f')
		return true
	else return false
	end
end

function up()
	-- check for obstructions
	if turtle.detectUp() then
		return false
	elseif turtle.up() then
		-- update position
		update('u')
		return true
	else return false
	end
end

function down()
	-- check for obstructions
	if turtle.detectDown() then
		return false
	elseif turtle.down() then
		-- update position
		update('d')
		return true
	else return false
	end
end


-- Long distance movement
function forwardTo(dist)
	if dist == nil then dist = 1 end
	local c = 0
	while c < dist do
		c=c+1
		if forward() == false then break end
	end
end

function upTo(dist)
	if dist == nil then dist = 1 end
	local c = 0
	while c < dist do
		c=c+1
		if up() == false then break end
	end
end

function downTo(dist)
	if dist == nil then dist = 1 end
	local c = 0
	while c < dist do
		c=c+1
		if down() == false then break end
	end
end


-- Complex motion
function moveTo(nx,ny,nz,nd)
	-- If some coords are omitted, asume no change
	if nx == nil then nx = xpos end
	if ny == nil then ny = ypos end
	if nz == nil then nz = zpos end
	if nd == nil then nd = dir end

	-- remember last position
	local cx, cy, cz = 0, 0, 0
	-- make 8 attempts to get to position, some pathfinding
	local tries = 0
	while tries < 8 do
		-- Align vertical position (y), if ascending
		if ypos<ny then	-- ascend
			upTo(ny-ypos)
		end

		-- if first attempt was unsuccessful, change order
		if (tries%2) == 0 then
			-- Align X
			if xpos>nx then
				face(1)
				forwardTo(xpos-nx)
			elseif xpos<nx then
				face(3)
				forwardTo(nx-xpos)
			end

			-- Align Z
			if zpos>nz then
				face(2)
				forwardTo(zpos-nz)
			elseif zpos<nz then
				face(0)
				forwardTo(nz-zpos)
			end
		else
			-- Align Z
			if zpos>nz then
				face(2)
				forwardTo(zpos-nz)
			elseif zpos<nz then
				face(0)
				forwardTo(nz-zpos)
			end
			
			-- Align X
			if xpos>nx then
				face(1)
				forwardTo(xpos-nx)
			elseif xpos<nx then
				face(3)
				forwardTo(nx-xpos)
			end
		end
		
		-- Align vertical position (y), if descending
		if ypos>ny then		-- descend
			downTo(ypos-ny)
		end
		
		if inPosition(nx,ny,nz) then break end
		
		-- if in the same position as last try, attemp to circumvent obstacle
		if cx == xpos then
			if cy == ypos then
				if cz == zpos then
					pathFind(tries)
					tries=tries-1
				end
			end
		end
		
		-- Remember current position
		cx = xpos
		cy = ypos
		cz = zpos
		
		tries=tries+1
	end

	-- Align direction
	face(nd)
end

-- Check target position
function inPosition(inx,iny,inz)
	if xpos == inx then
		if ypos == iny then
			if zpos == inz then return true end
		end
	end
	return false
end

-- Advanced pathfinding, more aggressive with more tries
-- Movement schematics:
-- 1  2  3
-- 0  X  4
function pathFind(level)
	if level%5 == 0 then
		left()
		local cl = 0
		while cl < level do
			forward()
			cl=cl+1
		end
	elseif level%5 == 1 then
		left()
		local cl = 0
		while cl < level do
			forward()
			up()
			cl=cl+1
		end
	elseif level%5 == 2 then
		left()
		local cl = 0
		while cl < level do
			up()
			cl=cl+1
		end
	elseif level%5 == 3 then
		right()
		local cl = 0
		while cl < level do
			forward()
			up()
			cl=cl+1
		end
	elseif level%5 == 4 then
		right()
		local cl = 0
		while cl < level do
			forward()
			cl=cl+1
		end
	end
end

-- Begin
initCoords()