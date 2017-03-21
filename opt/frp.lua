--Fisher Rednet Protocol
--Made by Fisher Medders - FisherMedders.com
--Free of use but do give credit.
--Started on 2/18/17 - In a hotel for SEWE 2017

function deargify( tArgs )
  sArgs = ""
  for i = 1, #tArgs-1 do
    sArgs = sArgs..tArgs[i]..":"
  end
  sArgs = sArgs..tArgs[#tArgs]
  return sArgs
end
    
function argify( sArgs )
  tArgs = {}
  for sArg in string.gmatch( sArgs, '([^:]+)' ) do
    table.insert( tArgs, sArg )
  end
  return tArgs
end

function receive( sProtocol, nTimeout )
  if nTimeout == nil then
    evnt = {os.pullEvent( "rednet_message" )}
    if string.find( evnt[3], sProtocol..":" ) then
      tArgs = argify( evnt[3] )
    end
  else
    if tonumber( nTimeout ) then
      evnt = {rednet.receive()}
      tArgs = argify( evnt[2] )
    else
      error("Receive was not nil, was also not a number.")
    end
  end
  return tArgs
end

function send( nId, tArgs )
  rednet.send( nId, deargify( tArgs ) )
end

function broadcast( tArgs )
  rednet.broadcast( deargify( tArgs ) )
end
