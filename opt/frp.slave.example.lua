--ICBM Missile Slave written for Andrew2070
--This is an example for the FRP Client by
--Fishermedders.com.

os.loadAPI( "frp" )
rednet.open( "top" )
tEnv = {
  ["list"] == {
    "missilesilo",
    "listmissiles",
  }
}

while true do
  tEvent = { os.pullEvent() }
  if tEvent[1] == "rednet_message" then
    if frp.argify( tEvent[3] ) ~= { } then
      tResults = frp.argify( tEvent[3] )
      if tResults == tEnv["list"] then
        -- Sending this information over rednet
        tToSend = {
          "Recieved",
          "SomeCoolInformation",
          "AboutTheMissile",
          "ReadyToLaunch",
        }
        frp.send( tEvent[2], tToSend ) -- Send back to reciever
      end
    end
  end
end
