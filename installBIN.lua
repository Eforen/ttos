fcl()
write("Setting up BootLoader for ")
--write("\n")
if fs.exists("/thinTurtleClient") then fs.delete("/thinTurtleClient") end
if fs.exists("/tc") then fs.delete("/tc") end
if fs.exists("/thinTurtleServer") then fs.delete("/thinTurtleServer") end
if fs.exists("/ts") then fs.delete("/ts") end
if turtle ~= nil then
	write("Turtle")
	fs.copy("/disk/thinTurtleClient.lua", "/thinTurtleClient")
	fs.copy("/disk/thinTurtleClientAPI.lua", "/tc")
else
	write("Server")
	fs.copy("/disk/thinTurtleServer.lua", "/thinTurtleServer")
	fs.copy("/disk/thinTurtleServerAPI.lua", "/ts")
end