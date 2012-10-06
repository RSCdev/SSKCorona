-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Standard Buttons & Sliders Callbacks
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local standardCallbacks = {}

-- ==================================================
-- == Simple table roller
-- ==
-- == * Used with push buttons.
-- == * Takes a table of button text values to initialize
-- == * Each button release changes to next text value in table (loops).
-- ==================================================
function standardCallbacks.prep_tableRoller( button, srcTable, chainedCB, underBarSwap ) 
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
	button._underBarSwap = underBarSwap or false	
end

function standardCallbacks.tableRoller_CB( event ) 
	local target        = event.target
	local srcTable		= target._srcTable
	local chainedCB     = target._chainedCB
	local underBarSwap  = target._underBarSwap
	local curText       = target:getText()
	local retVal        = true

	if(underBarSwap) then
		curText = curText:spaces2underbars(curText)
	end

	local j = 0
	for i = 1, #srcTable do
		dprint(2,tostring(srcTable[i]) .. " ?= " .. curText )
		if( tostring(srcTable[i]) == curText ) then
			j = i
			break
		end
	end

	j = j + 1

	if(j > #srcTable) then
		j = 1
	end


	if(underBarSwap) then
		target:setText( srcTable[j]:underbars2spaces() )
	else
		target:setText( srcTable[j] )
	end

	

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==================================================
-- == Set a Table Object from a list of values 
-- == each time the button is pressed.
-- ==================================================
function standardCallbacks.prep_table2TableRoller( button, dstTable, entryName, srcTable, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._srcTable = srcTable
	button._chainedCB = chainedCB
end

function standardCallbacks.table2TableRoller_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local srcTable = target._srcTable
	local chainedCB   = target._chainedCB
	local curText     = target:getText()
	local retVal      = true

	local j = 0
	for i = 1, #srcTable do
		if( srcTable[i] == curText ) then
			j = i
			break
		end
	end

	j = j + 1

	if(j > #srcTable) then
		j = 1
	end

	target:setText( srcTable[j] )
	dstTable[entryName] = srcTable[j] 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end

-- ==================================================
-- == Toggle a table value between true and false,
-- == each time the button is pressed.
-- ==================================================
function standardCallbacks.prep_tableToggler( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	dprint(2,"*******************************")
	dprint(2,entryName .. " == " ..  tostring(dstTable[entryName]) )
	if(dstTable[entryName] == true ) then
		button:toggle()
	end
end

function standardCallbacks.tableToggler_CB( event ) 
	local target      = event.target
	local dstTable   = target._dstTable
	local entryName   = target._entryname
	local chainedCB   = target._chainedCB
	local retVal      = true

	if(not dstTable) then
		return retVal
	end

	dstTable[entryName] = target:pressed() 

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end


-- ==================================================
-- == Horizontal Sliders
-- ==================================================
function standardCallbacks.prep_horizSlider2Table( button, dstTable, entryName, chainedCB ) 
	button._dstTable = dstTable
	button._entryname = entryName
	button._chainedCB = chainedCB

	local value = dstTable[entryName]

	local knob = button.myKnob

	button:setValue( value )
end

function standardCallbacks.horizSlider2Table_CB( event )
	local target     = event.target
	local myKnob     = target.myKnob
	local dstTable   = target._dstTable
	local entryName  = target._entryname
	local chainedCB  = target._chainedCB

	local retVal = true

	local newX = event.x

	local left = (target.x - target.width/2) + myKnob.width/2
	local right = (target.x + target.width/2) - myKnob.width/2
	local width = right-left

	if(newX < left) then
		newX = left
	elseif(newX > right) then
		newX = right
	end

	myKnob.x = newX

	target.value = (newX-left) / width
	target.value = tonumber(string.format("%1.2f", target.value))

	dprint(2, tostring(entryName) .. " Knob value == " .. target.value)

	if(dstTable and entryName) then
		dstTable[entryName] = target.value 
	end

	if( chainedCB ) then
		retVal = chainedCB( event )
	end

	return retVal
end
return standardCallbacks