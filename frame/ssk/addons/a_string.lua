-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- String Add-ons
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
-- Last Modified: 24 OCT 2012
-- =============================================================

--[[
h string:split
d Splits token (tok) separated string into integer indexed table.
d Modified: http://lua-users.org/wiki/SplitJoin
s string:split( tok )
s * tok - Name of file, optionally including subdirectory path.
r Integer indexed table containing all token separated elements of string.
e local animalString = "dogs,cats,birds"
e local animalTable  = animalString:split(",")
e for i = 1, #animalTable do
e    print(animalTable[i])
e end
e
d
d Prints:<br>
d dogs<br>
d cats<br>
d birds<br>
--]]
function string:split(tok)
	local str = self
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local ftok = "(.-)" .. tok
	local last_end = 1
	local s, e, cap = str:find(ftok, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(ftok, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

--[[
h string:getWord
d Gets indexed word from string, where words are separated by a single space (' ').
d Derived from same named Torque Script function
s string:getWord( index )
s * index - Word to get from string (starting at 1).
r String containing word at given index in source string.
e local animalString = "dogs cats birds"
e print( animalString:getWord(2) )
e 
d
d Prints:<br>
d dogs<br>
--]]
function string:getWord( index )
	local index = index or 1
	local aTable = self:split(" ")
	return aTable[index]
end

--[[
h string:getWordCount
d Counts words in a string, where words are separated by a single space (' ').
d Derived from same named Torque Script function
s string:getWordCount( )
r Number of words in string.
e local animalString = "dogs cats birds"
e print( animalString:getWordCount() )
e 
d
d Prints:<br>
d 3<br>
--]]
function string:getWordCount( )
	local aTable = self:split(" ")
	return #aTable
end

--[[
h string:getWords
d Gets indexed words from string, starting at ''index'' and ending at ''endindex'' or end of line if not specified.  
d Words are separated by a single space (' ').
d Derived from same named Torque Script function
s string:getWords( index [, endIndex ] )
s * index - First word in string to return.
s * endIndex - (optional) Last word in string to return.  If  no specified, endIndex is last word in source string.
r A string containing the requested words.
e local animalString = "dogs cats birds"
e print( animalString:getWords(2) )
e 
d
d Prints:<br>
d dogs<br>
d birds<br>
--]]
function string:getWords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split(" ")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.join(tmpTable, " ")

	return tmpString
end

--[[
h string:setWord
d Replaces indexed word in string with ''replace'', where words are separated by a single space (' ').
d Derived from same named Torque Script function
s string:setWord( index , replace )
s * index - Word to be replaced.
s * replace - String to place at position of old word.
r A string containing all of the original words except for the indexed word which is replaced by contents of ''replace''.
e local animalString = "dogs cats birds"
e 
e animalString = animalString:setWord( 2, "pigs horses cats" )
e
e print( animalString:getWords(2) )
e 
d
d Prints:<br>
d dogs pigs horses cats birds
--]]
function string:setWord( index, replace )
	local index = index or 1
	local aTable = self:split(" ")
	aTable[index] = replace
	local tmpString = table.join(aTable, " ")
	return tmpString
end



--[[
h string:getField
d Gets indexed field from string, where fields are separated by a single TAB ('\t').
d Derived from same named Torque Script function
s string:getField( index )
s * index - Field to get from string (starting at 1).
r String containing field at given index in source string.
e local animalString = "dogs\tcats\tbirds"
e print( animalString:getField(2) )
e 
d
d Prints:<br>
d dogs<br>
--]]
function string:getField( index )
	local index = index or 1
	local aTable = self:split("\t")
	return aTable[index]
end

--[[
h string:getFieldCount
d Counts fields in a string, where fields are separated by a single TAB ('\t').
d Derived from same named Torque Script function
s string:getFieldCount( )
r Number of fields in string.
e local animalString = "dogs\tcats\tbirds"
e print( animalString:getFieldCount() )
e 
d
d Prints:<br>
d 3<br>
--]]
function string:getFieldCount( )
	local aTable = self:split("\t")
	return #aTable
end

--[[
h string:getFields
d Gets indexed fields from string, starting at ''index'' and ending at ''endindex'' or end of line if not specified.  
d Fields are separated by a single TAB ('\t').
d Derived from same named Torque Script function
s string:getFields( index [, endIndex ] )
s * index - First field in string to return.
s * endIndex - (optional) Last field in string to return.  If  no specified, endIndex is last field in source string.
r A string containing the requested fields.
e local animalString = "dogs\tcats\tbirds"
e print( animalString:getFields(2) )
e 
d
d Prints:<br>
d dogs		birds<br>
--]]
function string:getFields( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\t")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.join(tmpTable, "\t")

	return tmpString
end

--[[
h string:setField
d Replaces indexed field in string with ''replace'', where fields are separated by a single TAB ('\t').
d Derived from same named Torque Script function
s string:setField( index , replace )
s * index - Field to be replaced.
s * replace - String to place at position of old field.
r A string containing all of the original fields except for the indexed field which is replaced by contents of ''replace''.
e local animalString = "dogs\tcats\tbirds"
e 
e animalString = animalString:setField( 2, "pigs\thorses\tcats" )
e
e print( animalString:getFields(2) )
e 
d
d Prints:<br>
d dogs pigs		horses		cats		birds
--]]
function string:setField( index, replace )
	local index = index or 1
	local aTable = self:split("\t")
	aTable[index] = replace
	local tmpString = table.join(aTable, "\t")
	return tmpString
end

--[[
h string:getRecord
d Gets indexed record from string, where records are separated by a single NEWLINE ('\n').
d Derived from same named Torque Script function
s string:getRecord( index )
s * index - Record to get from string (starting at 1).
r String containing record at given index in source string.
e local animalString = "dogs\ncats\nbirds"
e print( animalString:getRecord(2) )
e 
d
d Prints:<br>
d dogs<br>
--]]
function string:getRecord( index )
	local index = index or 1
	local aTable = self:split("\n")
	return aTable[index]
end

--[[
h string:getRecordCount
d Counts records in a string, where records are separated by a single NEWLINE ('\n').
d Derived from same named Torque Script function
s string:getRecordCount( )
r Number of records in string.
e local animalString = "dogs\ncats\nbirds"
e print( animalString:getRecordCount() )
e 
d
d Prints:<br>
d 3<br>
--]]
function string:getRecordCount( )
	local aTable = self:split("\n")
	return #aTable
end

--[[
h string:getRecords
d Gets indexed records from string, starting at ''index'' and ending at ''endindex'' or end of line if not specified.  
d Records are separated by a single NEWLINE ('\n').
d Derived from same named Torque Script function
s string:getRecords( index [, endIndex ] )
s * index - First record in string to return.
s * endIndex - (optional) Last record in string to return.  If  no specified, endIndex is last record in source string.
r A string containing the requested records.
e local animalString = "dogs\ncats\nbirds"
e print( animalString:getRecords(2) )
e 
d
d Prints:<br>
d dogs<br>
d birds<br>
--]]
function string:getRecords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\n")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.join(tmpTable, "\n")

	return tmpString
end

--[[
h string:setRecord
d Replaces indexed record in string with ''replace'', where records are separated by a single NEWLINE ('\n').
d Derived from same named Torque Script function
s string:setRecord( index , replace )
s * index - Record to be replaced.
s * replace - String to place at position of old record.
r A string containing all of the original records except for the indexed record which is replaced by contents of ''replace''.
e local animalString = "dogs\ncats\nbirds"
e 
e animalString = animalString:setRecord( 2, "pigs\nhorses\ncats" )
e
e print( animalString:getRecords(2) )
e 
d
d Prints:<br>
d dogs
d pigs
d horses
d cats
d birds
--]]
function string:setRecord( index, replace )
	local index = index or 1
	local aTable = self:split("\n")
	aTable[index] = replace
	local tmpString = table.join(aTable, "\n")
	return tmpString
end


--[[
h string:spaces2underbars
d Replaces all instances of spaces with underbars.
d Modified: http://lua-users.org/wiki/SplitJoin
s string:spaces2underbars( )
r Original string with all spaces replaced by underbars.
e local animalString = "dogs cats birds"
e 
e animalString = animalString:spaces2underbars
e
e print(animalString)
d
d Prints:<br>
d dogs_cats_birds
--]]
function string:spaces2underbars( )
	return self:gsub( "%s", "_" )
end

--[[
h string:underbars2spaces
d Replaces all instances of underbars with spaces.
d Modified: http://lua-users.org/wiki/SplitJoin
s string:underbars2spaces( )
r Original string with all underbars replaced by spaces.
e local animalString = "dogs_cats_birds"
e 
e animalString = animalString:underbars2spaces
e
e print(animalString)
d
d Prints:<br>
d dogs cats birds
--]]
function string:underbars2spaces( )
	return self:gsub( "_", " " )
end


--[[
h string:printf
d Replicates C-language printf().
d Modified: http://lua-users.org/wiki/LuaPrintf
s string:printf( ... )
s ... - Formatting string. (EFM fill in more data here)
r Returns formated string.
e  EFM - put example(s) here.
--]]
function string:printf(...)
	return io.write(self:format(...))
end -- function


--[[
h string:lpad
d Places padding on left side of a string, such that the new string is at least ''len'' characters long.
d Modified: http://megasnippets.com/source-codes/lua/pad_string_left
s string:lpad( len, char )
s * len - Minimum lenght of resulting string.
s * char - Character (or string) with which to pad original string.
r A string containing all of the original string and padded on the left side with ''char'' up to a minimum of  ''len'' lenght.
e local test = "SSK is cool!!!"
e
e test = test:lpad( 17, "!" )
e 
e print( test )
d
d Prints:<br>
d !!!SSK is cool!!!<br>
--]]
function string:lpad (len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return string.rep(char, len - #theStr) .. theStr
end

--[[
h string:rpad
d Places padding on right side of a string, such that the new string is at least ''len'' characters long.
d Modified: http://megasnippets.com/source-codes/lua/pad_string_right
s string:rpad( len, char )
s * len - Minimum lenght of resulting string.
s * char - Character (or string) with which to pad original string.
r A string containing all of the original string and padded on the right side with ''char'' up to a minimum of  ''len'' lenght.
e local test = "!!!SSK is cool"
e
e test = test:rpad( 17, "!" )
e 
e print( test )
d
d Prints:<br>
d !!!SSK is cool!!!<br>
--]]

function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end



