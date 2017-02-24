tUtils = fs.list("/bin/util/")
for i = 1,#tUtils do
  os.loadAPI("/bin/util/"..tUtils[i])
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
  environment.system.keys = {nil,"1","2","3","4","5","6","7","8","9","0",nil,nil,nil,nil,"q","w","e","r","t","y","u","i","o","p",nil,nil,nil,nil,"a","s","d","f","g","h","j","k","l",nil,nil,nil,nil,nil,"z","x","c","v","b","n","m"}
  environment.system.user = nil
  environment.system.dirs = {"bin","boot","dev","etc","home","lib","lost+found","misc","mnt","net","opt","proc","root","sbin","tmp","usr","var"}
  --Colors
  environment.colors.background = colors.black
  environment.colors.text = colors.white
  environment.colors.vanity = colors.red
--End Environmental Variable Setup

_G["exitcmd"] = false

users = {"fisher"}
passwords = {"fishae"}


function reset()
  term.setBackgroundColor(environment.colors.background)
  term.setTextColor(environment.colors.text)
end

function auth(user,pass)
  pwfile = fs.open("/etc/shadow","r")
  tbl = textutils.unserialize(pwfile.readAll())
  pwfile.close()
  for i = 1,#tbl do
  	for u = 1,#tbl[i] do
  	  if user == tbl[i][1] then
  	  	if str.SHA1(pass) == tbl[i][2] then
  		  environment.system.user = user
  		  return true
  		end
      end
    end
  end
  return false
end

function invisread()
  returnstr = ""
  term.setCursorBlink(true)
  while true do
    evnt = {os.pullEvent("key")}
      if evnt[2] == 14 then
          returnstr = returnstr:sub(1,#returnstr-1)
      elseif evnt[2] == 28 then
          break
      else
      	if environment.system.keys[evnt[2]] ~= nil then
          returnstr = returnstr..environment.system.keys[evnt[2]]
        end
      end
  end
  term.setCursorBlink(false)
  return returnstr
end

function login()
  reset()
  term.setCursorPos(1,1)
  term.clear()
  print("")
  print("FishOS Core release "..environment.system.branch.." "..os.computerID())
  print("")
  write("FOSC "..os.computerID().." login: ")
  user = read()
  write("Password: ")
  pass = invisread()
  print(" ")
  tbl = {}
  table.insert(tbl,user)
  table.insert(tbl,pass)
  return tbl
end

function dfind( sFile )
  if fs.exists( sFile ) then
  	if not fs.isDir( sFile ) then
  	  return true
  	end
  end
  return false
end

if fs.exists("/etc/shadow") then
  file = fs.open("/etc/shadow","r")
  tbl = textutils.unserialize(file.readAll())
  for i = 1,#tbl do
    if not fs.isDir("home/"..tbl[i][1]) then
      fs.makeDir("home/"..tbl[i][1])
    end
  end
  tbl = nil
end

for i = 1,#environment.system.dirs do
  if not fs.isDir(environment.system.dirs[i]) then
  	fs.makeDir(environment.system.dirs[i])
  end
end

if not fs.exists("/etc/shadow") then
  term.clear()
  term.setCursorPos(1,1)
  print("Welcome to FishOS, the only OS you'll need.")
  print(" ")
  print("FishOS has been customized to be very useful on the CL Tekkit server.")
  print(" ")
  print("We will now setup your first user account.")
  print("NOTE: You will be able to add more accounts later by using the command 'addusr'.")
  print("Also note, the password field will be invisible for security reasons.")
  term.write("User: ")
  user = read()
  term.write("Pass: ")
  pass = invisread()
  file = fs.open("/etc/shadow","w")
  ptbl = {}
  tbl = {}
  table.insert(tbl,user)
  table.insert(tbl,str.SHA1(pass))
  table.insert(ptbl,tbl)
  file.write(textutils.serialize(ptbl))
  file.close()
  print("User '"..user.."' added. Press any key to Continue!")
  os.pullEvent("key")
  os.reboot()
end

function boot()
  while true do
  	_G["logout"] = false
  	l = login()
    if auth(l[1],l[2]) then
      print("Welcome to FishOS Core Release "..environment.system.branch.." "..os.computerID())
      print(" ")
      print(" * Documentation: /usr/share/doc/")
      print(" * Support:       XMedders ingame")
      print(" ")
      print("[num] Packages can be updated.")
      print("[num] updates are security updates.")
      print(" ")
      print(" ")
      write("The programs included with the FishOS system are free software; the exact distribution terms for each program are described in the individual files in /usr/share/doc/copyright")
      print(" ")
      write("FishOS comes with no warranty, but ask XMedders ingame for a new copy and he will give ya one :D")
      print(" ")
      print(" ")
      print(" ")
      print("Press any Key to continue")
      os.pullEvent("key")
      while true do
        if _G["exitcmd"] or _G["logout"] then
          break
        end
        if shell.dir() == "" then
          dir = ""
        else
          dir = "/"..shell.dir()
        end
        label = ""
        if os.getComputerLabel() ~= nil then
          label = os.getComputerLabel()
        else
          label = "Comp"
        end
        write(environment.system.user.."@"..label.."-"..os.computerID()..":~"..dir.."$ ")
        console = read(nil, environment.system.terminal.cmds)
        table.insert(environment.system.terminal.cmds,console)
        found = false
        if console:gsub(" ","") ~= "" then
          args = {}
		  for arg in console:gmatch("%w+") do table.insert(args, arg) end
          if dfind("/bin/"..args[1]) then
          	found = true
          	shell.run("/bin/"..console)
          end
        end
        if not found then
          shell.run(console)
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
