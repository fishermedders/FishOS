tArgs = { ... }
if #tArgs == 1 then
  if tArgs[1]:lower() == "-s" then
    _G["exitcmd"] = true
  end
else
  _G["logout"] = true
end
