-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- EFM
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
-- Last Modified: 18 OCT 2012
-- =============================================================

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------


--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local tiles = {}

tiles.createTile = function(group, gx, gy, tileSize, imgSrc, colorsTable, strokeColor, tileTouchCB)
	local color = colorsTable[math.random(1,#colorsTable)]

	local curX =  gx * tileSize
	local curY =  gy * tileSize

	local strokeColor = strokeColor or _YELLOW_

	local theTile
	if(imgSrc == nil) then
		theTile = ssk.display.rect(group , curX, curY, { size = tileSize, fill = color, stroke = strokeColor } ) 
	else
		theTile = ssk.display.imageRect(group , curX, curY, imgSrc, { size = tileSize, fill = color } ) 
	end

	-- capture details for later
	theTile.gx,theTile.gy = gx,gy
	theTile.color = color

	dprint(2, theTile.gx,theTile.gy,colorNames[color])

	function theTile:randomizeColor( lastColor )
		local lastColor = lastColor or self.color
		local newColors = colorsTable
		local newColor = newColors[math.random(1,#newColors)]
		while newColor == lastColor do
			newColor = newColors[math.random(1,#newColors)]
		end
				
		self:setFillColor( unpack(newColor) )
		self.color = newColor
				
		dprint(2,self.gx, self.gy, colorNames[lastColor], colorNames[self.color])
				
		return newColor
	end

	theTile.touch = tileTouchCB

	theTile:addEventListener( "touch", theTile )		
end


return tiles