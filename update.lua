tUrls = {"/main.lua","/bin/list.lua","/bin/nano.lua","/bin/util/str.lua","/bin/logout.lua","/bin/cardboard.lua","/bin/addusr.lua","/bin/passwd.lua","/bin/util/fishutils.lua","/usr/share/doc/copyright.txt","/update.lua","/var/path/environment.pth"}
tDirs = {"/bin","/bin/util","usr/share/doc"}
tFiles = {{"/main"},{"/bin/list"},{"/bin/nano"},{"/bin/util/str"},{"/bin/logout"},{"/bin/cardboard"},{"/bin/addusr"},{"/bin/passwd"},{"/bin/util/fishutils"},{"usr/share/doc/copyright"},{"/bin/update"},{"/var/path/environment.pth"}}
sFSBase = "https://raw.githubusercontent.com/fishermedders/FishOS/master"

for i = 1,#tDirs do
  fs.makeDir(tDirs[i])
end

for i = 1,#tUrls do
  for i1 = 1,#tFiles[i] do
    oFile = fs.open(tFiles[i][i1],"w")
    print("Grabbing File: " .. tUrls[i] .. "from github!")
    sContent = http.get( sFSBase .. tUrls[i] ).readAll()
    oFile.write(sContent)
    oFile.close()
    --fs.delete(tFiles[i][i1])
    --shell.run("pastebin get "..tUrls[i].." "..tFiles[i][i1])
    print("Updated file "..tFiles[i][i1])
  end
end

if fs.exists("/startup") then
  fs.move("/startup","/startup_old.fos")
end

oFile = fs.open("startup", "w")
oFile.write("shell.run(\"main\")")
oFile.close()

oFile = fs.open(".startinstruct", "w")
oFile.write("fs.delete(\"update.lua\")")
oFile.close()

if _G["isdisk"] == nil then
  os.reboot()
end
