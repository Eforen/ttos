function load(dir)
	local FileList = fs.list(dir) --Table with all the files and directories available

	for _,file in ipairs( FileList ) do --Loop. Underscore because we don't use the key, ipairs so it's in order
		if fs.isDir(dir .. file) then -- isDir
			load(dir .. "/" .. file)
		else --isNotDir
			--table.insert(files, loc .. file)
			os.loadAPI(dir .. "/" .. file)
		end
	end --End the loop
end

load("/lib")