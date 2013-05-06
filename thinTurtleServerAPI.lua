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

function f(task, pos)
	task[pos] = "f"
	write(task[pos])
	return task
end
function b(task, pos)
	task[pos] = "b"
	write(task[pos])
	return task
end
function l(task, pos)
	task[pos] = "l"
	write(task[pos])
	return task
end
function r(task, pos)
	task[pos] = "r"
	write(task[pos])
	return task
end
function u(task, pos)
	task[pos] = "u"
	write(task[pos])
	return task
end
function d(task, pos)
	task[pos] = "d"
	write(task[pos])
	return task
end
function eot(task, pos)
	task[pos] = "eot"
	write(task[pos])
	return task
end