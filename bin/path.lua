--Path Appending Program!
tArgs = { ... }

if not fs.exists( "/var/path/environment.pth" ) then
  local oFile = fs.open( "/var/path/environment.pth", "w" )
  oFile.write( "{}" )
  oFile.close()
end

local function showHelp()
  print( "Path Appending Program | FishOS" )
  print( "Usage: path -a <path/to/files> (append)" )
  print( "Usage: path -l (list all path indexes)" )
  print( "Usage: path -r <index> (remove from path)" )
end

if #tArgs == 0 then
  showHelp()
else
  for i = 1,#tArgs do
    if tArgs[i] == "-a" or tArgs[i] == "--append" then
      if tArgs[i+1] ~= nil then
        local oFile = fs.open( "/var/path/environment.pth", "r" )
        local sContents = oFile.readAll()
        oFile.close()
        local tPath = textutils.unserialize( sContents )
        table.insert( tPath, tArgs[i+1] )
        local oFile = fs.open( "/var/path/environment.pth", "w" )
        oFile.write( textutils.serialise( tPath ) )
        oFile.close()
      end
    elseif tArgs[i] == "-l" or tArgs[i] == "--list" then
      local oFile = fs.open( "/var/path/environment.pth", "r" )
      local tPath = textutils.unserialize( oFile.readAll() )
      oFile.close()
      print("Path Listing!")
      for i = 1,#tPath do
        print(i .. ". " .. tPath[i] )
      end
    elseif tArgs[i] == "-r" or tArgs[i] == "--remove" then
      if tArgs[i+1] ~= nil then
        if tonumber( tArgs[i+1] ) then
          local oFile = fs.open( "/var/path/environment.pth", "r" )
          local tPath = textutils.unserialise( oFile.readAll() )
          oFile.close()
          local sRemovedPath = tPath[tonumber( tArgs[i+1] )]
          tPath[tonumber( tArgs[i+1] )] = nil
          local oFile = fs.open( "/var/path/environment.pth", "w" )
          oFile.write( textutils.serialise( tPath ) )
          oFile.close()
          print( "Successfully Removed Path Entry '" .. sRemovedPath .. "'!" )
        end
      end
    end
  end
end
