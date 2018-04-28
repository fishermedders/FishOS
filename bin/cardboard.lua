tArgs = { ... }

if #tArgs == 0 then
  print("Cardboard is a Package manager made by XMedders")
  print("[http://fishermedders.com]")
  print(" ")
  print("Usage: ")
  print("cardboard list")
  print("cardboard install [index]")
  print("cardboard info [index]")
  print(" ")
elseif #tArgs == 1 then
  if tArgs[1]:lower() == "list" then
    print(" ")
    repo = textutils.unserialize(http.get("http://pastebin.com/raw/J6gvZAxN").readAll())
    size = {term.getSize()}
    for _,p in pairs(repo) do
      info = repo[_]["name"].." by "..repo[_]["author"]
      dots = ""
      for i = 1,size[1]-#info-#_ do
        dots = dots.."."
      end
      print(_..dots..info)
    end
    print(" ")
  end
elseif #tArgs == 2 then
  if tArgs[1]:lower() == "install" then
    repo = textutils.unserialize(http.get("http://pastebin.com/raw/J6gvZAxN").readAll())
    for _,p in pairs(repo) do
      if tArgs[2]:lower() == _ then
        sFile = http.get(repo[_]["location"]).readAll()
        tFile = fs.open(repo[_]["target"],"w")
        tFile.write(sFile)
        tFile.close()
        print("File "..repo[_]["target"].." successfully cloned!")
      end
    end
  elseif tArgs[1]:lower() == "info" then
    repo = textutils.unserialize(http.get("http://pastebin.com/raw/J6gvZAxN").readAll())
    for _,p in pairs(repo) do
      if tArgs[2]:lower() == _ then
        print(" ")
        print(repo[_]["name"].." by "..repo[_]["author"])
        print("")
        print("Other info:")
        for i = 1,#repo[_]["notes"] do
          print(" - "..repo[_]["notes"][i])
        end
        print(" ")
      end
    end
  end
end
