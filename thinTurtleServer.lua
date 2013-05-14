os.loadAPI('/ts')

local task = {0}
local count = 1
local args = 1

--Main

local running = true

ts.open()

while running do
	event, var2, var3, var4 = os.pullEvent()
	if event == 'key' then
		if keys.getName(var2) == '1' then
			args = 1
		elseif keys.getName(var2) == '2' then
			args = 2
		elseif keys.getName(var2) == '3' then
			args = 3
		elseif keys.getName(var2) == '4' then
			args = 4
		elseif keys.getName(var2) == '5' then
			args = 5
		elseif keys.getName(var2) == '6' then
			args = 6
		elseif keys.getName(var2) == '7' then
			args = 7
		elseif keys.getName(var2) == '8' then
			args = 8
		elseif keys.getName(var2) == '9' then
			args = 9
		elseif keys.getName(var2) == '0' then
			args = 10
		elseif keys.getName(var2) == 'w' then
			task = ts.f(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 's' then
			task = ts.b(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'a' then
			task = ts.l(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'd' then
			task = ts.r(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'e' then 
			task = ts.u(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'c' then
			task = ts.d(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'r' then
			task = ts.du(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'f' then 
			task = ts.df(task, count + 1, args)
			count = count + 1
		elseif keys.getName(var2) == 'v' then
			task = ts.db(task, count + 1, args)
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
