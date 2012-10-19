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
local tiles = require("ssk_sampler.games.puzzle1.shared.tiles")

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local boardMgr = {}

boardMgr.createBoard = function ( group, x, y, tileSize, rows, cols, tileBuilder, tileTouchCB )
	local theBoard = display.newGroup()

	group:insert( theBoard )

	local colors = { _RED_, _GREEN_ , _BLUE_ } --, _YELLOW_, _PURPLE_, _PINK_ }	
	
	theBoard.maxX = cols
	theBoard.maxY = rows

	dprint(2,"Starting  board layout loop...")
	for gy=1, rows do
		for gx=1, cols do
			tileBuilder( theBoard, gx, gy, tileSize, imagesDir .. "lostGardenGem2.png", colors, nil, tileTouchCB)
			--tileBuilder( theBoard, gx, gy, tileSize, nil, colors, _PINK_, tileTouchCB )
		end
	end

	theBoard:setReferencePoint( display.CenterReferencePoint )

	theBoard.x = x
	theBoard.y = y

	function theBoard:dropReplacementTile( gx, gy, maxX, maxY ) -- EFM tile function instead?
	end

	function theBoard:settleColumn( col )

		local mx = self.maxX
		local my = self.maxY

		local x = col 
		local y = my
		while y > 0 do
			local theTile = self[x + (y - 1) * mx]
			if (not theTile.isVisible) then
				local y2 = y - 1
				while y2 > 0 do
					local theTile2 = self[x + (y2 - 1) * mx]
					if (theTile2.isVisible) then
						theTile.color = theTile2.color
						theTile:setFillColor( unpack( theTile.color ) )
						theTile2.isVisible = false
						theTile.isVisible = true
						y2 = 0
					end
					y2 = y2 - 1
				end
			end
			y = y-1
		end
		
	end

	function theBoard:fillColumn( col )

		local mx = self.maxX
		local my = self.maxY

		local x = col 
		local y = my
		local lastColor = nil
		while y > 0 do
			local theTile = self[x + (y - 1) * mx]
			if (not theTile.isVisible) then
				lastColor = theTile:randomizeColor( lastColor )
				theTile.isVisible = true
			end
			y = y-1
		end
		
	end

	function theBoard:settleAndFillColumn( col, fillDelay )

		local mx = self.maxX
		local my = self.maxY

		-- 1. Drop Pass
		local x = col 
		local y = my
		while y > 0 do
			local theTile = self[x + (y - 1) * mx]
			if (not theTile.isVisible) then
				local y2 = y - 1
				while y2 > 0 do
					local theTile2 = self[x + (y2 - 1) * mx]
					if (theTile2.isVisible) then
						theTile.color = theTile2.color
						theTile:setFillColor( unpack( theTile.color ) )
						theTile2.isVisible = false
						theTile.isVisible = true
						y2 = 0
					end
					y2 = y2 - 1
				end
			end
			y = y-1
		end

		-- 2. Fill Pass
		local x = col 
		local y = my
		local lastColor = nil
		while y > 0 do
			local theTile = self[x + (y - 1) * mx]
			if (not theTile.isVisible) then
				lastColor = theTile:randomizeColor( lastColor )
				if(fillDelay and fillDelay > 0) then
					local closure = function() theTile.isVisible = true end
					timer.performWithDelay( fillDelay, closure )
				else
					theTile.isVisible = true
				end
			end
			y = y-1
		end
		
	end


	function theBoard:getAllNeighbors( gx, gy, maxX, maxY )
		local neighborBlocks = {}
		for x = -1, 1 do
			for y = -1, 1 do

				local index = (gy + y - 1) * maxX + (x + gx)
				dprint(2, x,y, index)
				if( (x + gx) >     0 and
				    (x + gx) <= maxX and
					(y + gy) >     0 and
					(y + gy) <= maxY and
					index <= self.numChildren ) then
					neighborBlocks[#neighborBlocks+1] = self[index]
				end
			end
		end
		return neighborBlocks
	end

	-- Left-to-Right Downward Diagonal
	function theBoard:getSameColorLRDiagonalDownNeighbors( startingTile, distanceLimit)
		local color = startingTile.color
		local  gx, gy, maxX, maxY =  startingTile.gx, startingTile.gy, self.maxX, self.maxY
		local neighborBlocks = { }

		local y = gy-1
		local x = gx-1
		local matching = true
		
		while x > 0 and y > 0 and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "L", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x - 1
			y = y - 1
		end
		
		y = gy
		x = gx
		matching = true

		while x <= maxX and y <= maxY and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "R", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x + 1
			y = y + 1
		end

		return neighborBlocks
	end

	-- Left-to-Right Upward Diagonal
	function theBoard:getSameColorLRDiagonalUpNeighbors( startingTile, distanceLimit )
		local color = startingTile.color
		local  gx, gy, maxX, maxY =  startingTile.gx, startingTile.gy, self.maxX, self.maxY
		local neighborBlocks = { }

		local y = gy+1
		local x = gx-1
		local matching = true

		while x > 0 and y <= maxY and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "L", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x - 1
			y = y + 1
		end
		
		y = gy
		x = gx
		matching = true

		while x <= maxX and y > 0 and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "R", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x + 1
			y = y - 1
		end

		return neighborBlocks
	end

	function theBoard:getSameColorRowNeighbors( startingTile, distanceLimit)
		local color = startingTile.color
		local  gx, gy, maxX, maxY =  startingTile.gx, startingTile.gy, self.maxX, self.maxY
		local neighborBlocks = { }

		local y = gy
		local x = gx-1
		local matching = true
		
		while x > 0 and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "L", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x - 1
		end
		
		y = gy
		x = gx
		matching = true

		while x <= maxX and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "R", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			x = x + 1
		end

		return neighborBlocks
	end


	function theBoard:getSameColorColNeighbors( startingTile, distanceLimit)
		local color = startingTile.color
		local  gx, gy, maxX, maxY =  startingTile.gx, startingTile.gy, self.maxX, self.maxY
		local neighborBlocks = { }

		local y = gy-1
		local x = gx
		local matching = true
		
		while y > 0 and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "U", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			y = y - 1
		end
		
		y = gy
		x = gx
		matching = true

		while y <= maxY and matching == true do
			local index = (y - 1) * maxX + x
			dprint(2, "D", x, y, index, colorNames[self[index].color])
			if( self[index].color == color ) then					
				neighborBlocks[#neighborBlocks+1] = self[index]
			else 
				matching = false
			end

			y = y + 1
		end

		return neighborBlocks
	end


	function theBoard:getSameColorNeighbors( startingTile )
		local color = startingTile.color
		local  gx, gy, maxX, maxY =  startingTile.gx, startingTile.gy, self.maxX, self.maxY
		local neighborBlocks = {}
		for x = -1, 1 do
			for y = -1, 1 do

				local index = (gy + y - 1) * maxX + (x + gx)
				dprint(2, x,y, index)
				if( (x + gx) >     0 and
				    (x + gx) <= maxX and
					(y + gy) >     0 and
					(y + gy) <= maxY and
					index <= self.numChildren and
					self[index].color == color ) then
					
					neighborBlocks[#neighborBlocks+1] = self[index]
				end
			end
		end
		return neighborBlocks
	end

	function theBoard:getAllConnectedSameColor( startingTile, distanceLimit )
		local returnBlocks = { startingTile }
		returnBlocks[startingTile] = true 
		i = 1
		while i <= #returnBlocks do

			local allAdjacent = self:getSameColorNeighbors( returnBlocks[i] )

			for j = 1, #allAdjacent do
				local aBlock = allAdjacent[j]
				if not returnBlocks[aBlock] then
					returnBlocks[aBlock] = true 
					returnBlocks[#returnBlocks+1] = aBlock
				end
			end

			if distanceLimit and i >= distanceLimit then
				return returnBlocks
			end

			i = i + 1

		end

		return returnBlocks
	end

	return theBoard
end  -- createBoard
return boardMgr