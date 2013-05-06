-- Simple GUI printing API v0.2


-- Empty box
function box(mon,x,y,w,h)
	-- draw top left corner
	mon.setCursorPos( x, y )
	mon.write('+')
	-- draw top line
	local cx = 2
	while cx < w do
		mon.write('-')
		cx=cx+1
	end
	-- draw top right corner
	mon.write('+')
	-- draw bottom left corner
	mon.setCursorPos( x, y+h-1 )
	mon.write('+')
	-- draw bottom line
	local cx = 2
	while cx < w do
		mon.write('-')
		cx=cx+1
	end
	-- draw bottom right corner
	mon.write('+')
	-- draw left line
	local cy = 2
	while cy < h do
		mon.setCursorPos( x, y+cy-1 )
		mon.write('|')
		cy=cy+1
	end
	-- draw right line
	local cy = 2
	while cy < h do
		mon.setCursorPos( x+w-1, y+cy-1 )
		mon.write('|')
		cy=cy+1
	end
end

-- Text at position
function text(mon,x,y,text)
	mon.setCursorPos( x, y )
	mon.write(text)
end

-- Blank box - covers text behind it
function bbox(mon,x,y,w,h)
	local cy = 1
	while cy <= h do
		mon.setCursorPos( x, (y+cy-1) )
		local cx = 1
		while cx <= w do
			if cx == 1 or cx == w then
				if cy == 1 or cy == h then
					mon.write('+')
				else
					mon.write('|')
				end
			elseif cy == 1 or cy == h then
				mon.write('-')
			else
				mon.write(' ')
			end
			cx=cx+1
		end
		cy=cy+1
	end
end

-- Highlighted box
function hbox(mon,x,y,w,h)
	-- draw top left corner
	mon.setCursorPos( x, y )
	mon.write('#')
	-- draw top line
	local cx = 2
	while cx < w do
		mon.write('=')
		cx=cx+1
	end
	-- draw top right corner
	mon.write('#')
	-- draw bottom left corner
	mon.setCursorPos( x, y+h-1 )
	mon.write('#')
	-- draw bottom line
	local cx = 2
	while cx < w do
		mon.write('=')
		cx=cx+1
	end
	-- draw bottom right corner
	mon.write('#')
	-- draw left line
	local cy = 2
	while cy < h do
		mon.setCursorPos( x, y+cy-1 )
		mon.write('[')
		cy=cy+1
	end
	-- draw right line
	local cy = 2
	while cy < h do
		mon.setCursorPos( x+w-1, y+cy-1 )
		mon.write(']')
		cy=cy+1
	end
end


-- CList class
clist = {}
clist.__index = clist

-- New instance
function clist.create(inx,iny,inlist)
	local object = {}
	
	setmetatable(object,clist)
	
	object.x = inx
	object.y = iny
	
	object.list = inlist
	object.state = 1
	object.len = table.maxn(inlist)
	object.w = 1
	
	-- set menu width
	local mw = 0
	for i,v in ipairs(inlist) do if mw < string.len(v) then mw = string.len(v) end end
	object.w = mw
	
	return object
end

-- Define items
function clist:set(inlist)
	self.list = inlist
	self.len = table.maxn(inlist)
	
	-- set menu width
	local mw = 0
	for i,v in ipairs(inlist) do if mw < string.len(v) then mw = string.len(v) end end
	object.w = mw
end
	
-- Manage input
function clist:input(inevent, inkey)
	if inevent == 'key' then
		if inkey == 200 then
			if self.state == 1 then self.state = self.len
			else self.state = self.state-1 end
		elseif inkey == 208 then
			if self.state == self.len then self.state = 1
			else self.state = self.state+1 end
		elseif inkey == 28 then
			-- Enter key is pressed, send current active item
			return self.state
		end
	end
end

-- Print to screen
function clist:out(mon)
	local cx, cy = self.x, self.y
	for index, item in ipairs(self.list) do
		mon.setCursorPos(cx,cy)
		if index==self.state then
			mon.write('[_'..item)
			local cw = self.w - string.len(item)
			while cw > 0 do
				mon.write('_')
				cw=cw-1
			end
			mon.write('_]')
		else mon.write('  '..item)
		end
		cy=cy+1
	end
end