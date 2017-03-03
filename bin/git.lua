if not fs.exists( "json" ) then
  json = fs.open( "json", "w" )
  json.write( http.get( "https://raw.githubusercontent.com/fishermedders/cc/master/jsonapi" ).readAll() )
  json.close()
  print( "Installed the JsonAPI by Elvish Jerrico!" )
end

os.loadAPI( "json" )
tArgs = { ... }
environment = {
  ["version"] = "1.0",
  ["helpmsg"] = {
    "git [--version] [--help] [-C <path>]",
    "[-c <name>=<value>] [--exec-path[=<path>]]",
    "[--html-path] [--man-path] [--info-path]",
    "[-p|--paginate|--no-pager] [--no-replace-objects]",
    "[--bare] [--git-dir=<path>] [--work-tree=<path>]",
    "[--namespace=<name>] [--super-prefix=<path>]",
    "<command> [<args>]",
  }
}

-- character table string
b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

-- encoding
function enc(data)
  return ((data:gsub('.', function(x) 
    local r,b='',x:byte()
    for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
    return r;
  end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
    if (#x < 6) then return '' end
    local c=0
    for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
    return b:sub(c+1,c+1)
  end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec(data)
  data = string.gsub(data, '[^'..b..'=]', '')
  return (data:gsub('.', function(x)
    if (x == '=') then return '' end
    local r,f='',(b:find(x)-1)
    for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
    return r;
  end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
    if (#x ~= 8) then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c)
  end))
end

local function errorMessage( oError )
  local nColor = term.getTextColor()
  term.setTextColor( colors.red )
  if type( oError ) == "string" then
    print( oError )
  elseif type( oError ) == "table" then
    for i = 1,#oError do
      print( oError[i] )
    end
  end
  term.setTextColor( nColor )
end

function buildArgs( tWebArgs )
  local returnstr = ""
  for i = 1,#tWebArgs do
    if i == 1 then
      returnstr = returnstr .. "?" .. tWebArgs[i][1] .. "=" .. tWebArgs[i][2]
    else
      returnstr = returnstr .. "&" .. tWebArgs[i][1] .. "=" .. tWebArgs[i][2]
    end
  end
  return returnstr
end

local function downloadRepo( sUser, sRepo, sBranch)
  table.insert( tCurlArgs, { "recursive", "1" } )
  local sResults = http.get( "https://api.github.com/repos/" .. sUser .. "/" .. sRepo .. "/git/trees/" .. sBranch .. buildArgs( tCurlArgs ) ).readAll()
  local tResults = json.decode( sResults )
  for i = 1,#tResults["tree"] do
    if tResults["tree"][i]["type"] == "blob" then
      local sBlob = http.get( tResults["tree"][i]["url"] ).readAll()
      local tBlob = json.decode( sBlob )
      local oFile = fs.open( shell.dir() .. "/" .. sRepo .. "/" .. tResults["tree"][i]["path"], "w" )
      oFile.write( dec( tBlob["content"] ) )
      print("Downloading File " .. tResults["tree"][i]["path"] .. "!" )
      oFile.close()
    end
  end
end


nCommandIndex = nil
tCurlArgs = {}
sBranch = "master"
for i = 1,#tArgs do
  sCurrentArg = tArgs[i]:lower()
  if sCurrentArg == "--version" or sCurrentArg == "-v" then
    errorMessage( "Git Client for ComputerCraft! v" .. environment.version )
    errorMessage( "Made by Fisher Medders | FisherMedders.com" )
  elseif sCurrentArg == "--help" or sCurrentArg == "-h" then
    errorMessage( environment.helpmsg )
  elseif sCurrentArg == "--token" or sCurrentArg == "-t" then
    if tArgs[i+1] ~= nil then
      table.insert( tCurlArgs, { "access_token", tArgs[i+1] } )
    end
  elseif sCurrentArg == "-b" or sCurrentArg == "--branch" then
    if tArgs[i+1] ~= nil then
      sBranch = tArgs[i+1]
    end
  elseif sCurrentArg == "clone" then
    if tArgs[i+1] ~= nil then
      if http.checkURL( tArgs[i+1] ) then
        if string.find( tArgs[i+1], "https://github.com/" ) then
          if tArgs[i+1]:sub( #tArgs[i+1]-4, #tArgs[i+1] ) then
            sParts = tArgs[i+1]:gsub( "https://github.com/", "" )
            sParts = sParts:gsub( ".git", "" )
            nStart, nEnd = string.find( sParts, "/" )
            sUser = sParts:sub( 1, nStart-1 )
            sRepo = sParts:sub( nEnd+1, #sParts )
            downloadRepo( sUser, sRepo, sBranch )
          end
        end
      end
    end
  end
end
