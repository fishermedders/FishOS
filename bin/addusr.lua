tArgs = { ... }

if #tArgs == 1 then
  file = fs.open("/etc/shadow","r")
  tbl = textutils.unserialize(file.readAll())
  file.close()
  for i = 1,#tbl do
  	if tbl[i][1] == tArgs[1] then
  	  term.setTextColor(colors.red)
  	  print("This username is already taken! Please use another one.")
  	  term.setTextColor(colors.white)
  	  break
  	else
	  term.write("Password: ")
	  pass = str.SHA1(invisread())
	  print(" ")
	  tArgs[2] = pass
	  table.insert(tbl,tArgs)
	  file = fs.open("/etc/shadow","w")
	  file.write(textutils.serialize(tbl))
	  file.close()
	  print("Successfully added user '"..tArgs[1].."'!")
	  break
	end
  end
else
  term.setTextColor(colors.red)
  print("Usage: addusr <user>")
  term.setTextColor(colors.white)
end
