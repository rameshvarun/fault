--[[ Requires all of the lua scripts in a given directory
The 2nd argument specifies whether or not to descend recursively.
Defaults to recursive. ]]--
function require_dir(dir, recursive)
  -- Default for recursive is true.
	if recursive == nil then recursive = true end

	local files = love.filesystem.getDirectoryItems(dir)
	for _, file in ipairs(files) do
		if  love.filesystem.isFile( dir .. "/" .. file ) then
			if string.sub(file, -4, -1) == ".lua" then
				modulename = string.sub(file, 0, -5)
				require(dir .. "/" .. modulename)
			end
		end
	end

  -- Recurse into subdirectories.
	if recursive then
		for _, file in ipairs(files) do
			if love.filesystem.isDirectory( dir .. "/" .. file ) then
				require_dir( dir .. "/" .. file, recursive)
			end
		end
	end
end
