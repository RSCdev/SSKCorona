-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Table Add-ons
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
-- Last Modified: 29 AUG 2012
-- =============================================================

local json = require( "json" )

-- ======================================================================
-- join - Join indexed table entries into string with specified seprator
-- ======================================================================
function table.join( aTable, sep)
	local newString = aTable[1]
	
	for i=2, #aTable do
		newString = newString .. sep .. aTable[i]
	end

	return newString
end

-- ======================================================================
-- shallowCopy - Copys single-level tables; handles non-integer indexes; does not copy metatable
-- ======================================================================
function table.shallowCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		dst[k] = v
	end
	return dst
end

-- ======================================================================
-- deepCopy - Copys multi-level tables; handles non-integer indexes; does not copy metatable
-- ======================================================================
function table.deepCopy( src, dst )
	local dst = dst or {}
	for k,v in pairs(src) do 
		if( type(v) == "table" ) then
			dst[k] = table( v, nil )
		else
			dst[k] = v
		end		
	end
	return dst
end

-- ======================================================================
-- save - Saves table to file (Uses JSON library as intermediary)
-- ======================================================================
function table.save( theTable, fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	fh = io.open( path, "w" )
	if(fh) then
		fh:write(json.encode( theTable ))
		io.close( fh )
		return true
	end	
	return false
end

-- ======================================================================
-- load - Loads table from file (Uses JSON library as intermediary)
-- ======================================================================
function table.load( fileName, base )
	local base = base or  system.DocumentsDirectory
	local path = system.pathForFile( fileName, base )
	local fh, reason = io.open( path, "r" )
	local contents	
	if fh then
		contents = fh:read( "*a" )
		io.close( fh )
	end
	local newTable = json.decode( contents )
	return newTable
end

-- ======================================================================
-- dump - Dumps indexes and values inside single-level table (for debug)
-- ======================================================================
function table.dump(theTable, padding )
	local padding = padding or 30
	print("\Table Dump:")
	print("-----")
	if(theTable) then
		for k,v in pairs(theTable) do 
			local key = tostring(k)
			local value = tostring(v)
			local keyType = type(k)
			local valueType = type(v)
			local keyString = key .. " (" .. keyType .. ")"
			local valueString = value .. " (" .. valueType .. ")" 

			keyString = keyString:rpad(padding)
			valueString = valueString:rpad(padding)

			print( keyString .. " == " .. valueString ) 
		end
	else
		print("empty")
	end
	print("-----\n")
end


