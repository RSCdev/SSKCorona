-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Various Global Functions
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

-- Return first argument that is not nil
function fnn( ... ) 
	for i = 1, #arg do
		local theArg = arg[i]
		if(theArg ~= nil) then return theArg end
	end
	return nil
end

---============================================================
-- Calculate Pascal's triangle to 'n' rows and return as a sequence
-- Modified: http://rosettacode.org/wiki/Pascal's_triangle#Lua
function _G.PascalsTriangle_row(t)
  local ret = {}
  t[0], t[#t+1] = 0, 0
  for i = 1, #t do ret[i] = t[i-1] + t[i] end
  return ret
end

function _G.PascalsTriangle(n)
  local t = {1}
  local full = nil

  for i = 1, n do
	if full then
		full = table.copy(full,t)
	else
		full = table.copy(t)
	end
    t = _G.PascalsTriangle_row(t)
  end
  return full
end

function _G.PascalsTriangle_lastRow(n)
  local t = {1}
  for i = 1, n do
    t = _G.PascalsTriangle_row(t)
  end
  return t
end


---============================================================
-- Calculate fibbonaci out to nth place (with caching for speedup)
-- http://en.literateprograms.org/Fibonacci_numbers_(Lua)
_G.fibs={[0]=0, 1, 1} 
function _G.fastfib(n)
	for i=3,n do
		_G.fibs[i]=_G.fibs[i-1]+_G.fibs[i-2]
	end
	return _G.fibs[n]
end

---============================================================
-- rounds a number to the nearest decimal places
-- http://lua-users.org/wiki/FormattingNumbers
function _G.round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

---============================================================
-- add comma to separate thousands
-- http://lua-users.org/wiki/FormattingNumbers
function _G.comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end

--===================================================================
-- given a numeric value formats output with comma to separate thousands
-- and rounded to given decimal places
-- http://lua-users.org/wiki/FormattingNumbers
function _G.format_num(amount, decimal, prefix, neg_prefix)
  local str_amount,  formatted, famount, remain

  decimal = decimal or 2  -- default 2 decimal places
  neg_prefix = neg_prefix or "-" -- default negative sign

  famount = math.abs(round(amount,decimal))
  famount = math.floor(famount)

  remain = round(math.abs(amount) - famount, decimal)

        -- comma to separate the thousands
  formatted = comma_value(famount)

        -- attach the decimal portion
  if (decimal > 0) then
    remain = string.sub(tostring(remain),3)
    formatted = formatted .. "." .. remain ..
                string.rep("0", decimal - string.len(remain))
  end

        -- attach prefix string e.g '$' 
  formatted = (prefix or "") .. formatted 

        -- if value is negative then format accordingly
  if (amount<0) then
    if (neg_prefix=="()") then
      formatted = "("..formatted ..")"
    else
      formatted = neg_prefix .. formatted 
    end
  end

  return formatted
end
