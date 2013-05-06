-- Config Storage v0.1

pvpath = "config/"
if fs.exists(pvpath) == false then fs.makeDir(pvpath) end

function is(pvname)
	pvfile = io.open(pvpath..pvname..".ini", "r")
	if pvfile then
		pvfile:close()
		return true  
	else
		return false
	end
end

function new(pvname)
	pvfile = io.open(pvpath..pvname..".ini", "r")
	if pvfile then
		pvfile:close()
		return false  
	else
		pvfile = io.open(pvpath..pvname..".ini","w")
		pvfile:close()
		return true
	end
end

function set(pvname, newvalue)
	pvfile = io.open(pvpath..pvname..".ini", "r")
	if pvfile then
		pvfile:close()
		pvfile = io.open(pvpath..pvname..".ini","w")
		pvfile:write(newvalue)
		pvfile:close()
		return newvalue
	else
		return false
	end
end

function get(pvname)
	pvfile = io.open(pvpath..pvname..".ini", "r")
	if pvfile then
		pvcontent = pvfile:read()
		pvfile:close()
		return pvcontent
	else
		return false
	end
end

function delete(pvname)
	pvfile = io.open(pvpath..pvname..".ini", "r")
	if pvfile then
		pvfile:close()
		fs.delete(pvpath..pvname..".ini")
		return true
	else
		return false 
	end
end
