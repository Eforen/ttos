fcl()
write("Setting up BootLoader for ")
--write("\n")
fs.delete("/thinTurtleClient")
fs.delete("/tc")
fs.delete("/thinTurtleServer")
fs.delete("/ts")
if turtle ~= nil then
	write("Turtle")
	fs.copy("/disk/thinTurtleClient.lua", "/thinTurtleClient")
	fs.copy("/disk/thinTurtleClientAPI.lua", "/tc")
else
	write("Server")
	fs.copy("/disk/thinTurtleServer.lua", "/thinTurtleServer")
	fs.copy("/disk/thinTurtleServerAPI.lua", "/ts")
end