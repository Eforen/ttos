os.loadAPI('/tc')

function procMsg( msg )
	-- body
	for i = 1, msg[1]+1, 1 do
        if msg[i] == "f" then
        	tc.f()
    	elseif msg[i] == "b" then
    		tc.b()
    	elseif msg[i] == "l" then
    		tc.tl()
    	elseif msg[i] == "r" then
    		tc.tr()
    	elseif msg[i] == "u" then
    		tc.u()
    	elseif msg[i] == "d" then
    		tc.d()
        end
    end
end

--Main

local running = true

tc.open()

while running do
	event, var2, var3 = os.pullEvent()
	if event == 'key' then
	--elseif event == 'timer' and var2 == tc.broadcastAliveTimer then
	--	tc.broadcastAlive()
	elseif event == 'rednet_message' then
		print( "saw: \"" .. var3 .. "\"")
		if string.starts(var3, "ttsm: ") then
			msg = textutils.unserialize(string.sub(var3,string.len("ttsm: ")))
			procMsg(msg)
		end
	end
end
