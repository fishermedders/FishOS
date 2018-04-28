--FishOS Main Operating File -- 
--FishOS is an operating system for
--ComputerCraft, (computercraft.lua)
--and uses LUA. This is an example of
--an operating system that you can
--build on top of craftos.

if fs.exists( ".startinstruct" ) then
  shell.run( ".startinstruct" )
end

tUtils = fs.list( "/bin/util/" )
for i = 1,#tUtils do
  os.loadAPI( "/bin/util/" .. tUtils[i] )
end

--Start Environment Variables Setup
environment = {
  ["system"]={
  	["keys"]={},
  	["terminal"]={
  		["cmds"]={}
  	},
    ["dirs"]={}
  },
  ["colors"]={}
}

--System
environment.system.branch = "dev1"
environment.system.keys = { nil, "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", nil, nil, nil, nil, "q", "w", "e", "r", "t", "y", "u", "i", "o", "p", nil, nil, nil, nil, "a", "s", "d", "f", "g", "h" ,"j", "k", "l", nil, nil, nil, nil, nil, "z", "x", "c", "v", "b", "n", "m" } 
environment.system.user = nil
environment.system.dirs = { "bin", "boot", "dev", "etc", "home", "lib", "lost+found", "misc", "mnt", "net", "opt", "proc", "root", "sbin", "tmp", "usr", "var" }
--Colors
environment.colors.background = colors.black
environment.colors.text = colors.white
environment.colors.vanity = colors.red
--End Environmental Variable Setup

_G["exitcmd"] = false

function reset()
  term.setBackgroundColor( environment.colors.background )
  term.setTextColor( environment.colors.text )
end

function auth( sUser, sPass )
  local oFile = fs.open( "/etc/shadow", "r" )
  local tPass = textutils.unserialize( oFile.readAll() )
  oFile.close()
  for i = 1,#tPass do
  	for u = 1,#tPass[i] do
  	  if sUser == tPass[i][1] then
  	  	if str.SHA1(sPass) == tPass[i][2] then
  		  environment.system.user = sUser
  		  return true
  		end
      end
    end
  end
  return false
end

function invisread()
  local sReturn = ""
  term.setCursorBlink( true )
  while true do
    tEvent = { os.pullEvent( "key" ) }
    if tEvent[2] == 14 then
      sReturn = sReturn:sub( 1, #sReturn-1 )
    elseif tEvent[2] == 28 then
      break
    else
     	if environment.system.keys[tEvent[2]] ~= nil then
        sReturn = sReturn .. environment.system.keys[tEvent[2]]
      end
    end
  end
  term.setCursorBlink( false )
  return sReturn
end

function login()
  reset()
  term.setCursorPos( 1, 1 )
  term.clear()
  print( "" )
  print( "FishOS Core release " .. environment.system.branch .. " " .. os.computerID() )
  print( "" )
  write( "FOSC " .. os.computerID() .. " login: " )
  local sUser = read()
  write( "Password: " )
  local sPass = invisread()
  print( " " )
  local tAuth = {}
  table.insert(tAuth,sUser)
  table.insert(tAuth,sPass)
  return tAuth
end

function dfind( sFile )
  if fs.exists( sFile ) then
   	if not fs.isDir( sFile ) then
  	   return true
  	 end
  end
  return false
end

if fs.exists( "/etc/shadow" ) then
  local oFile = fs.open( "/etc/shadow", "r" )
  tPass = textutils.unserialize( oFile.readAll() )
  oFile.close()
  for i = 1,#tPass do
    if not fs.isDir( "home/" .. tPass[i][1] ) then
      fs.makeDir( "home/" .. tPass[i][1] )
    end
  end
  tPass = nil
end

for i = 1,#environment.system.dirs do
  if not fs.isDir( environment.system.dirs[i] ) then
  	fs.makeDir( environment.system.dirs[i] )
  end
end

if not fs.exists( "/etc/shadow" ) then
  term.clear()
  term.setCursorPos( 1, 1 )
  print( "Welcome to FishOS, the only OS you'll need." )
  print( " " )
  print( "FishOS has been customized to be very useful on the CL Tekkit server." )
  print( " " )
  print( "We will now setup your first user account." )
  print( "NOTE: You will be able to add more accounts later by using the command 'addusr'." )
  print( "Also note, the password field will be invisible for security reasons." )
  term.write( "User: " )
  local sUser = read()
  term.write( "Pass: " )
  local sPass = invisread()
  local oFile = fs.open( "/etc/shadow", "w" )
  local tPass = {}
  local tTmp = {}
  table.insert( tTmp, sUser )
  table.insert( tTmp, str.SHA1( sPass ) )
  table.insert( tPass, tTmp )
  tTmp = nil
  oFile.write( textutils.serialize( tPass ) )
  oFile.close()
  tPass = nil
  print( "User '" .. user .. "' added. Press any key to Continue!" )
  os.pullEvent( "key" )
  os.reboot()
end

function boot()
  while true do
  	 _G["logout"] = false
  	 l = login()
    if auth( l[1], l[2] ) then
      print( "Welcome to FishOS Core Release " .. environment.system.branch .. " " .. os.computerID() )
      print( " " )
      print( " * Documentation: /usr/share/doc/" )
      print( " * Support:       XMedders ingame" )
      print( " " )
      print( "[num] Packages can be updated." )
      print( "[num] updates are security updates." )
      print( " " )
      print( " " )
      write( "The programs included with the FishOS system are free software; the exact distribution terms for each program are described in the individual files in /usr/share/doc/copyright" )
      print( " " )
      write( "FishOS comes with no warranty, but ask XMedders ingame for a new copy and he will give ya one :D" )
      print( " " )
      print( " " )
      print( " " )
      print( "Press any Key to continue" )
      os.pullEvent( "key" )
      while true do
        if _G["exitcmd"] or _G["logout"] then
          break
        end
        if shell.dir() == "" then
          dir = ""
        else
          dir = "/" .. shell.dir()
        end
        local sLabel = ""
        if os.getComputerLabel() ~= nil then
          sLabel = os.getComputerLabel()
        else
          sLabel = "Comp"
        end
        write( environment.system.user .. "@" .. sLabel .. "-" .. os.computerID() .. ":~" .. dir .. "$ " )
        local sInput = read( nil, environment.system.terminal.cmds )
        table.insert( environment.system.terminal.cmds, sInput )
        local bFound = false
        if sInput:gsub( " ", "" ) ~= "" then
          local tArgs = {}
          if sInput:find( " " ) then
		          for sArg in sInput:gmatch( "%S+" ) do
              table.insert( tArgs, sArg )
            end
          else
            tArgs[1] = sInput
          end
          local oFile = fs.open( "/var/path/environment.pth", "r" )
          local tPath = textutils.unserialise( oFile.readAll() )
          oFile.close()
          local sArgs = ""
          if #tArgs >= 2 then
            for i = 2,#tArgs do
              sArgs = sArgs .. tArgs[i] .. " "
            end
          end
          for i = 1,#tPath do
            if dfind( tPath[i] .. "/" .. tArgs[1] .. ".lua" ) then
             	bFound = true
             	shell.run( tPath[i] .. "/" .. tArgs[1] .. ".lua " .. sArgs )
            end
          end
        end
        if not bFound then
          shell.run(sInput)
        end
        reset()
      end
    end
    if _G["exitcmd"] then
      break
    end
  end
end

boot()
