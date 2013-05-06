local sOpenedSide = nil

function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

local function open()
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

function procMsg( msg )
	-- body
end

while running do
	event, var2, var3 = os.pullEvent()
	if event == 'key' then
	elseif event == 'timer' and var2 == broadcastAliveTimer then
		broadcastAlive()
	elseif event == 'rednet_message' then
		if string.starts(var2, "ttsm: ") then
			msg = serialize.deserialize(string.sub(var2,string.len("ttsm: ")))
		end
	end
end
