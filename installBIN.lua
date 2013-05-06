fcl()
write("Setting up BootLoader for ")
--write("\n")
fs.delete("/thinTurtleClient")
fs.delete("/thinTurtleServer")
if turtle ~= nil then
	write("Turtle")
	fs.copy("/disk/thinTurtleClient.lua", "/thinTurtleClient")
else
	write("Server")
	fs.copy("/disk/thinTurtleServer.lua", "/thinTurtleServer")
end