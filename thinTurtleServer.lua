os.loadAPI('/ts')

local task = {0}
local count = 1

--Main

local running = true

ts.open()

while running do
	event, var2, var3 = os.pullEvent()
	if event == 'key' then
		if keys.getName(var2) == 'w' then
			task = ts.f(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 's' then
			task = ts.b(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'a' then
			task = ts.l(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'd' then
			task = ts.r(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'e' then 
			task = ts.u(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'c' then
			task = ts.d(task, count + 1)
			count = count + 1
		elseif keys.getName(var2) == 'enter' then
			task = ts.eot(task, count + 1)
			task[1] = count
			rednet.broadcast("ttsm: " .. textutils.serialize(task))
			write("\n-Sent\n")
			task = {0}
			count = 1
		end
	elseif event == 'timer' and var2 == broadcastAliveTimer then
		broadcastAlive()
	elseif event == 'rednet_message' then
	end
end
