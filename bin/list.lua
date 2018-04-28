
local tArgs = { ... }

-- Get all the files in the directory
local sDir = shell.dir()
if tArgs[1] ~= nil then
	sDir = shell.resolve( tArgs[1] )
end

-- Sort into dirs/files, and calculate column count
local tAll = fs.list( sDir )
local tFiles = {}
local tDirs = {}
local fFiles = {}

for n, sItem in pairs( tAll ) do
	if string.sub( sItem, 1, 1 ) ~= "." then
		local sPath = fs.combine( sDir, sItem )
		if fs.isDir( sPath ) then
			if sPath ~= "rom" then
				table.insert( tDirs, sItem )
			end
		else
			local ffile = false
			if #sItem >= 3 then
				if sItem:sub(#sItem-2,#sItem) == ".ff" then
					table.insert( fFiles, sItem )
					ffile = true
				end
			end
			if not ffile then
				table.insert( tFiles, sItem )
			end
		end
	end
end
table.sort( tDirs )
table.sort( tFiles )

if term.isColour() then
	textutils.pagedTabulate( colors.blue, tDirs, colors.white, tFiles, colors.red, fFiles )
else
	textutils.pagedTabulate( tDirs, tFiles )
end
