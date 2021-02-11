local shell = require("shell")
 
shell.setWorkingDirectory("/")
 
loadfile("/bin/wget.lua")("-f", "https://raw.githubusercontent.com/LeadSeason/Refill/master/refill.lua", "/home/refill.lua")
loadfile("/home/refill.lua")()