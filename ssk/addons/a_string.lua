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
-- Last Modified: 29 AUG 2012
-- =============================================================

-- ======================================================================
-- split - Splits token (tok) separated string into integer indexed table
-- http://lua-users.org/wiki/SplitJoin (modified)
-- ======================================================================
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

-- ======================================================================
-- getWord - Gets indexed word from string, where words are separated by a single space (' ').
-- Derived from same named Torque Script function
-- ======================================================================
function string:getWord( index )
	local index = index or 1
	local aTable = self:split(" ")
	return aTable[index]
end

-- ======================================================================
-- getWordCount - Counts words in a string, where words are separated by a single space (' ').
-- Derived from same named Torque Script function
-- ======================================================================
function string:getWordCount( )
	local aTable = self:split(" ")
	return #aTable
end

-- ======================================================================
-- getWords - Gets indexed words from string, starting at 'index' and ending at 'endindex' or end of line if not
-- specified.  Words are separated by a single space (' ').
-- Derived from same named Torque Script function
-- ======================================================================
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

-- ======================================================================
-- setWord - Replaces indexed word in string with 'replace', where words are separated by a single space (' ').
-- Derived from same named Torque Script function
-- ======================================================================
function string:setWord( index, replace )
	local index = index or 1
	local aTable = self:split(" ")
	aTable[index] = replace
	local tmpString = table.join(aTable, " ")
	return tmpString
end



-- Same as getWord, except strings are separated by TAB ('\t') character.
function string:getField( index )
	local index = index or 1
	local aTable = self:split("\t")
	return aTable[index]
end

-- Same as getWordCount, except strings are separated by TAB ('\t') character.
function string:getFieldCount( )
	local aTable = self:split("\t")
	return #aTable
end

-- Same as getWords, except strings are separated by TAB ('\t') character.
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

-- Same as setWord, except strings are separated by TAB ('\t') character.
function string:setField( index, replace )
	local index = index or 1
	local aTable = self:split("\t")
	aTable[index] = replace
	local tmpString = table.join(aTable, "\t")
	return tmpString
end

-- Same as getWord, except strings are separated by NEWLINE ('\n') character.
function string:getRecord( index )
	local index = index or 1
	local aTable = self:split("\n")
	return aTable[index]
end

-- Same as getWordCount, except strings are separated by NEWLINE ('\n') character.
function string:getRecordCount( )
	local aTable = self:split("\n")
	return #aTable
end

-- Same as getWords, except strings are separated by NEWLINE ('\n') character.
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

-- Same as setWord, except strings are separated by NEWLINE ('\n') character.
function string:setRecord( index, replace )
	local index = index or 1
	local aTable = self:split("\n")
	aTable[index] = replace
	local tmpString = table.join(aTable, "\n")
	return tmpString
end



-- ===================
-- spaces2underbars() - replaces all instances of spaces with underbars
-- underbars2spaces() - replaces all instances of underbars with spaces
-- ===================
function string:spaces2underbars( )
	return self:gsub( "%s", "_" )
end
function string:underbars2spaces( )
	return self:gsub( "_", " " )
end


-- ======================================================================
-- printf - Replicates C language printf()
-- http://lua-users.org/wiki/LuaPrintf (modified)
-- ======================================================================
function string:printf(...)
	return io.write(self:format(...))
end -- function


-- ======================================================================
-- lpad - Pads string (on left side of original) with specified 'char' up to lenght 'len'
-- Pad Left - http://megasnippets.com/source-codes/lua/pad_string_left (modified)
-- ======================================================================
function string:lpad (len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return string.rep(char, len - #theStr) .. theStr
end

-- ======================================================================
-- rpad - Pads string (on right side of original) with specified 'char' up to lenght 'len'
-- Pad Right - http://megasnippets.com/source-codes/lua/pad_string_right (modified)
-- ======================================================================
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end



