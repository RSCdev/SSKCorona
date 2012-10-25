-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- main.lua
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSK library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSK or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSK and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Last Modified: 23 OCT 2012
-- =============================================================

print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")
io.output():setvbuf("no") -- Don't use buffer for console messages

function measureFunc( path )
	local first = _G.last
	local var = require( path ) 
	_G.last = collectgarbage("count")
	if(string.lpad) then
		
		print( (path .. ": "):lpad(40)  .. tostring(round( last-first, 0 )):lpad(4)  .. " K Bytes"  )
	else
		print(path .. ": " .. last-first  .. "K Bytes " )
	end
	
	return var
end

collectgarbage()
collectgarbage("stop")
_G.first = collectgarbage("count")
_G.last = _G.first

require( "ssk.globals" ) -- Load Standard Globals

_G.last = collectgarbage("count")
if(round) then
	print("ssk.globals" .. ": " .. round( last-first, 2 )  .. "K Bytes " )
else
	print("ssk.globals" .. ": " .. last-first  .. "K Bytes " )
end

require("loadnMeasureSSK")

_G.last = collectgarbage("count")
print("Full SSK Lib: " .. round( last-first, 2 )  .. "K Bytes " )




print("\n****************************************************************")
print("*********************** /\\/\\ main.cs /\\/\\ **********************")
print("****************************************************************")
