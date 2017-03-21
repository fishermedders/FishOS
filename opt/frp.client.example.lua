--ICBM Client written for Andrew2070.
--This is an example for the FRP Client by
--FisherMedders.com.

os.loadAPI( "frp" )
tPastEntries = { }

while true do
  sInput = read( nil, tPastEntries )
  table.insert( tPastEntries, sInput )
  if sInput == "list" then
    -- Broadcast that you want to receive information back about each missile.
    frp.broadcast( {
      "missilesilo",
      "listmissiles",
    } )
    nCnt = 0
    while true do
      tMissiles = { } -- Where the missile ids are stored.
      os.startTimer(3) -- Timeout 3 Seconds
      tEvent = { os.pullEvent() }
      if tEvent[1] == "rednet_message" then
        tRecieved = frp.argify( tEvent[3] )
        table.insert( tMissiles, tRecieved )
      elseif tEvent[1] == "timer" then
        break
      end
    end
    print( "We received information about " .. #tMissiles .. " missiles!" )
  end
end
