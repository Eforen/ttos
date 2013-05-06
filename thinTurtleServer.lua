os.loadAPI("ts")

local task = {0}
local count = 1

--Main
ts.open()
while running do
	event, var2, var3 = os.pullEvent()
	if event == 'key' then
		if keys.getName(var2) == 'w' then
			ts.f(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 's' then
			ts.b(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'a' then
			ts.l(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'd' then
			ts.r(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'e' then 
			ts.u(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'c' then
			ts.d(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'enter' then
			ts.eot(task, count + 1)
			task[1] = count
			rednet.broadcast("ttsm: " .. serialize.serialize(task))
			task = {0}
			count = 1
		end
	elseif event == 'timer' and var2 == broadcastAliveTimer then
		broadcastAlive()
	elseif event == 'rednet_message' then
	end
end
