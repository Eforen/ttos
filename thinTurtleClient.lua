os.loadAPI('/tc')

function procMsg( msg )
	-- body
	for i = 1, msg[1]+1, 1 do
        if msg[i].action == "f" then
            tc.rpt(tc.f, msg[i].args)
    	elseif msg[i].action == "b" then
    		tc.rpt(tc.b, msg[i].args)
    	elseif msg[i].action == "l" then
    		tc.rpt(tc.tl, msg[i].args)
    	elseif msg[i].action == "r" then
    		tc.rpt(tc.tr, msg[i].args)
    	elseif msg[i].action == "u" then
    		tc.rpt(tc.u, msg[i].args)
        elseif msg[i].action == "d" then
            tc.rpt(tc.d, msg[i].args)
        elseif msg[i].action == "du" then
            tc.rpt(tc.dig, msg[i].args)
        elseif msg[i].action == "df" then
            tc.rpt(tc.digUp, msg[i].args)
        elseif msg[i].action == "dd" then
            tc.rpt(tc.digDown, msg[i].args)
        elseif msg[i].action == "da" then
            tc.rpt(tc.digAll, msg[i].args)
        elseif msg[i].action == "db" then
            tc.rpt(tc.digBoth, msg[i].args)
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
