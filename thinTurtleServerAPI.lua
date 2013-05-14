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

function f(task, pos, var)
	task[pos] = {action="f", args=cvar}
	write(task[pos])
	return task
end
function b(task, pos, var)
	task[pos] = {action="b", args=cvar}
	write(task[pos])
	return task
end
function l(task, pos, var)
	task[pos] = {action="l", args=cvar}
	write(task[pos])
	return task
end
function r(task, pos, var)
	task[pos] = {action="r", args=cvar}
	write(task[pos])
	return task
end
function u(task, pos, var)
	task[pos] = {action="u", args=cvar}
	write(task[pos])
	return task
end
function d(task, pos, var)
	task[pos] = {action="d", args=cvar}
	write(task[pos])
	return task
end
function d(task, pos, var)
	task[pos] = {action="d", args=cvar}
	write(task[pos])
	return task
end
function du(task, pos, var)
	task[pos] = {action="du", args=cvar}
	write(task[pos])
	return task
end
function df(task, pos, var)
	task[pos] = {action="df", args=cvar}
	write(task[pos])
	return task
end
function dd(task, pos, var)
	task[pos] = {action="dd", args=cvar}
	write(task[pos])
	return task
end
function da(task, pos, var)
	task[pos] = {action="da", args=cvar}
	write(task[pos])
	return task
end
function db(task, pos, var)
	task[pos] = {action="db", args=cvar}
	write(task[pos])
	return task
end
function eot(task, pos, var)
	task[pos] = {action="eot", args=cvar}
	write(task[pos])
	return task
end