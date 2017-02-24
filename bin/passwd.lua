tArgs = { ... }

if #tArgs == 1 then
  userfile = fs.open("/etc/shadow","r")
  ufiletext = userfile.readAll()
  userfile.close()
  users = textutils.unserialize(ufiletext)
  found = false
  for i = 1,#users do
    if users[i][1] == tArgs[1] then
      found = true
      print("New password: ")
      pass = invisread()
      users[i][2] = str.SHA1(pass)
      pass = nil
      userfile = fs.open("/etc/shadow","w")
      userfile.write(textutils.serialise(users))
      userfile.close()
      print(" ")
      print("Successfully changed password of user '"..users[i][1].."'!")
      break
    end
  end
else
  term.setTextColor(colors.red)
  print("Usage: passwd <user>")
  term.setTextColor(colors.white)
end
