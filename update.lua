tUrls = {"vd7rG2Ue","Wc9ia7Kr","vt3hV9kC","PYWjbzxb","K2aPQ2zp","ZxLvG9z4","x1ybNtea","MmGY8T2U","ycV50AzP","uxFQZyTV","8FrqEbLJ"}
tDirs = {"/bin","/bin/util","usr/share/doc"}
tFiles = {{"/startup"},{"/bin/list","/bin/ls"},{"/bin/nano"},{"/bin/util/str"},{"/bin/logout"},{"/bin/cardboard"},{"/bin/addusr"},{"/bin/passwd"},{"/bin/util/fishutils"},{"usr/share/doc/copyright"},{"/bin/update"}}

for i = 1,#tDirs do
  fs.makeDir(tDirs[i])
end

--No longer needed, we host on github now :)
--[[for i = 1,#tUrls do
  for i1 = 1,#tFiles[i] do
    fs.delete(tFiles[i][i1])
    shell.run("pastebin get "..tUrls[i].." "..tFiles[i][i1])
    print("Updated file "..tFiles[i][i1])
  end
end]]--

if fs.exists("/startup") then
  fs.move("/startup","/startup_old.fos")
end

oFile = fs.open( "startup", "w" )
oFile.write( "shell.run(\"main.lua\")" )
oFile.close()

if _G["isdisk"] == nil then
  os.reboot()
end
