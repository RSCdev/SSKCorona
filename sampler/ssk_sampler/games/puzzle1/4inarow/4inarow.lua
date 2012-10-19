-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Template #1
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
--[[				NOTES
   This is a BASIC connect 3 game with no special effects.  It has these mechanics:
   - Touch two tiles to swap them. (Only for horizontally or vertically adjacent tiles.)
   - Swapping triggers a scan for matches.
   - Matches are only horizontal and vertical.
   - When matching color rows/cols of length 3 or more are formed, all tiles that 
     formed the match are removed from the board.
	 - getSameColorRowNeighbors(), getSameColorColNeighbors()
   - After all tiles are removed from the board after all matched tiles are removed, columns
     will be 'settled' and new tiles will be dropped in to each column.
   - After all tiles have settled and all new tiles have dropped in, a match check will be run
     against all settled and new tiles.  
   - The match,remove,settle cycle will repeat until no new matches occur.
   - The board starts of pre-stacked and may contain untriggered matches.
--]]
--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local theBoard
local gameLabel
local winnerLabel
local gameOver = false

local currentColor = _RED_

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

local numCols = 6
local numRows = 5
local tileSize = screenWidth/numCols
if(tileSize > screenHeight/numRows) then
	tileSize = screenHeight/numRows
end

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createTile
local createBoard

local onResetBoard

local onTouchDropTile 

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	createCollisionCalculator()

	-- 2. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 3. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 4. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	theBoard = createBoard( layers.content, centerX, centerY, tileSize, numRows, numCols, createTile, onTouchDropTile)

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	theBoard = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false
end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:dump()
end


createLayers = function( group )
	layers = ssk.proto.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	backImage = ssk.proto.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.proto.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	-- Add generic direction and input buttons
	local tmpButton
	-- Universal Buttons

	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onResetBoard )

	gameLabel = ssk.labels:presetLabel( layers.interfaces, "default", "4-in-a-row", centerX, h - 20, { fontSize = 24 } )

	winnerLabel = ssk.labels:presetLabel( layers.interfaces, "default", colorNames[currentColor] .. "'s turn", centerX, 20, { fontSize = 24 } )
end	


onResetBoard = function ( event )	
	theBoard:removeSelf()
	theBoard = createBoard( layers.content, centerX, centerY, tileSize, numRows, numCols, createTile, onTouchDropTile)
	currentColor = _RED_ 
	winnerLabel:setText(colorNames[currentColor] .. "'s turn")
	gameOver = false
end


-- Drop a tile in the current row
onTouchDropTile = function(self, event)
	local target  = event.target
	local eventID = event.id
	local parent  = target.parent

	if( gameOver) then return true end


	if(event.phase == "ended" or event.phase == "cancelled") then
		print(" Do touch drop ", self.gx, self.gy )
		local droppedTile = theBoard:dropTile( self.gx )
		if(droppedTile) then
		local checkResults = theBoard:getSameColorLRDiagonalDownNeighbors(droppedTile)
		if #checkResults >= 4 then
			print( colorNames[droppedTile.color] .. " won!" )
			winnerLabel:setText( colorNames[droppedTile.color] .. " won!" )
			gameOver = true
		end 

		checkResults = theBoard:getSameColorLRDiagonalUpNeighbors(droppedTile)
		if #checkResults >= 4 then
			print( colorNames[droppedTile.color] .. " won!" )
			winnerLabel:setText( colorNames[droppedTile.color] .. " won!" )
			gameOver = true
		end 

		checkResults = theBoard:getSameColorRowNeighbors(droppedTile)
		if #checkResults >= 4 then
			print( colorNames[droppedTile.color] .. " won!" )
			winnerLabel:setText( colorNames[droppedTile.color] .. " won!" )
			gameOver = true
		end 

		checkResults = theBoard:getSameColorColNeighbors(droppedTile)
		if #checkResults >= 4 then
			print( colorNames[droppedTile.color] .. " won!" )
			winnerLabel:setText( colorNames[droppedTile.color] .. " won!" )
			gameOver = true
		end 


		end
	end

	return true
end


createBoard = function ( group, x, y, tileSize, rows, cols, tileBuilder, tileTouchCB )
	local aBoard = display.newGroup()

	group:insert( aBoard )

	local colors = { _DARKGREY_ } 
	
	aBoard.maxX = cols
	aBoard.maxY = rows

	dprint(2,"Starting  board layout loop...")
	for gy=1, rows do
		for gx=1, cols do
			tileBuilder( aBoard, gx, gy, tileSize, imagesDir .. "chip.png", tileTouchCB)
		end
	end

	aBoard:setReferencePoint( display.CenterReferencePoint )

	aBoard.x = x
	aBoard.y = y

	function aBoard:dropTile( col )

		local mx = self.maxX
		local my = self.maxY

		local x = col 
		local y = my
		while y > 0 do
			local theTile = self[x + (y - 1) * mx]
			if (theTile.color == _DARKGREY_) then
				theTile.color = currentColor
				theTile:setFillColor( unpack( theTile.color ) )

				if( currentColor == _RED_ ) then
					currentColor = _BLUE_ 
				else
					currentColor = _RED_ 
				end
				winnerLabel:setText(colorNames[currentColor] .. "'s turn")

				return theTile
			end
			y = y-1
		end

		return nil
		
	end

	function aBoard:getSameColorRowNeighbors( startingTile, distanceLimit)
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


	function aBoard:getSameColorColNeighbors( startingTile, distanceLimit)
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


	-- Left-to-Right Downward Diagonal
	function aBoard:getSameColorLRDiagonalDownNeighbors( startingTile, distanceLimit)
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
	function aBoard:getSameColorLRDiagonalUpNeighbors( startingTile, distanceLimit )
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

	return aBoard
end  -- createBoard

createTile = function(group, gx, gy, tileSize, imgSrc, tileTouchCB)
	local color = _DARKGREY_

	local curX =  gx * tileSize
	local curY =  gy * tileSize

	local strokeColor = strokeColor or _YELLOW_

	local theTile
	if(imgSrc == nil) then
		theTile = ssk.proto.rect(group , curX, curY, { size = tileSize, fill = color, stroke = strokeColor } ) 
	else
		theTile = ssk.proto.imageRect(group , curX, curY, imgSrc, { size = tileSize, fill = color } ) 
	end

	-- capture details for later
	theTile.gx,theTile.gy = gx,gy
	theTile.color = color

	dprint(2, theTile.gx,theTile.gy,colorNames[color])


	theTile.touch = tileTouchCB

	theTile:addEventListener( "touch", theTile )		
end

return gameLogic