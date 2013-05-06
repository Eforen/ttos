local onBox = false

function sp( seconds )
	if releaseVersion then
		os.sleep( seconds )
	end
end

write("Creating Install Cache...\n")
-- Lib format
-- {
--	string = Verbos name
--	string = file path relitive to /lib/,
--	string = install location relitive to /lib/
--	boolean = autoload
-- }
--	
dirs = {
	"gui", "net", "util", "turtle"
}
libs = {
	{"Serialize API", "net/serialize.lua", "net/serialize", true},
	{"Graphic Interface API", "gui/gui.lua", "gui/gui", true},
	{"Config API", "util/config.lua", "util/config", true},
	{"Vector API", "util/vector.lua", "util/vector", true},
	{"Common Methods API", "util/common.lua", "util/common", true},
	{"SmartMove API", "turtle/smartmove.lua", "turtle/smartmove", true}
}
sp( 0.4 )


write("Creating lib dir...\n")
sp( 0.4 )

fs.makeDir("/lib")
for i,dir in ipairs(dirs) do
	write("Creating lib/" .. dir)
	fs.makeDir("/lib/" .. dir)
	sp( 0.3 )
	write(" *OK*\n")
	sp( 0.1 )
end
write("\n")
sp( 0.3 )



write("Installing lib files to dir...\n")
sp( 0.4 )

for i,lib in ipairs(libs) do
	write("Installing lib " .. lib[1])
	fs.delete ("/lib/" .. lib[3])
	fs.copy("/disk/lib/" .. lib[2], "/lib/" .. lib[3])
	sp( 0.3 )
	write(" *OK*\n")
	sp( 0.1 )
end
write("APIs Installed\n\n")
sp( 0.3 )



write("Loading apis...\n")
sp( 0.4 )

for i,lib in ipairs(libs) do
	write("Loading api " .. lib[3])
	os.loadAPI('/lib/' .. lib[3])
	sp( 0.3 )
	write(" *OK*\n")
	sp( 0.1 )
end

write("APIs Loaded\n\n")
sp( 0.3 )

write("Setting API Boot Loaders\n\n")
sp( 0.3 )