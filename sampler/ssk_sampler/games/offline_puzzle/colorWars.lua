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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								REQUIRES							--
----------------------------------------------------------------------
local boardMgr = require("ssk_sampler.games.puzzle1.shared.board")
local tiles = require("ssk_sampler.games.puzzle1.shared.tiles")

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local theBlocks
local matchingMode = "LRDiagonalUpAdjacent" --"allAdjacent"
local matchingLabel
local scoreHUD

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = 320 -- smaller than actual to allow for overlay/frame
local screenHeight = 240 -- smaller than actual to allow for overlay/frame
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createBoard = boardMgr.createBoard
local createSky

local onDown
local onRowMatch
local onColMatch
local onResetBoard

local touch_findMatching 
local touch_swap 

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
	--createSky(centerX, centerY, screenWidth, screenHeight )
	theBlocks = createBoard( layers.content, centerX, centerY, 40, 6, 8, tiles.createTile, touch_findMatching)

end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	theBlocks = nil

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
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "C_Button",  screenLeft-30, screenBot-225, 42, 42, "", onAnyMatch )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "D_Button", screenLeft-30, screenBot-175, 42, 42, "", onColMatch )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "E_Button", screenLeft-30, screenBot-125, 42, 42, "", onRowMatch )	

	tmpButton = ssk.buttons:presetPush( layers.interfaces, "F_Button",  screenLeft-30, screenBot-75, 42, 42, "", onDiagonalMatchLR)	
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button",  screenLeft-30, screenBot-25, 42, 42, "", onDiagonalMatchRL)	
	-- Universal Buttons
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onResetBoard )

	matchingLabel = ssk.labels:presetLabel( layers.interfaces, "default", "Match " .. matchingMode, centerX, h - 20,
										    { fontSize = 24 } )

	scoreHUD = ssk.huds:createNumericScoreHUD( centerX, 20, 9, "default", layers.interfaces, {fontSize = 24, color = _WHITE_ })
	scoreHUD:set(0)

end	


createSky = function ( x, y, width, height  )
	local sky  = ssk.proto.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

-- Movement/General Button Handlers
onAnyMatch = function ( event )
	matchingMode = "allAdjacent"
	matchingLabel:setText( "Match " .. matchingMode )
end

onRowMatch = function ( event )
	matchingMode = "rowAdjacent"
	matchingLabel:setText( "Match " .. matchingMode )
end

onColMatch = function ( event )
	matchingMode = "colAdjacent"
	matchingLabel:setText( "Match " .. matchingMode )
end

onDiagonalMatchLR = function ( event )
	matchingMode = "LRDiagonalDownAdjacent"
	matchingLabel:setText( "Match " .. matchingMode )
end

onDiagonalMatchRL = function ( event )
	matchingMode = "LRDiagonalUpAdjacent"
	matchingLabel:setText( "Match " .. matchingMode )
end

onResetBoard = function ( event )	
	theBlocks:removeSelf()
	theBlocks = createBoard( layers.content, centerX, centerY, 40, 6, 8, tiles.createTile, touch_findMatching)
	scoreHUD:set(0)
end


-- Find Matching Touch handler
touch_findMatching = function(self, event)
	local target  = event.target
	local eventID = event.id

	if(event.phase == "began") then
		dprint(1, "Touched a tile with color: " .. colorNames[target.color])
		dprint(2, target.gx, target.gy)
					
		local neighbors
		if( matchingMode == "allAdjacent") then
			neighbors = target.parent:getAllConnectedSameColor(target, nil)
		elseif( matchingMode == "colAdjacent") then
			neighbors = target.parent:getSameColorColNeighbors(target, nil)
		elseif( matchingMode == "rowAdjacent") then
			neighbors = target.parent:getSameColorRowNeighbors(target, nil)
		elseif( matchingMode == "LRDiagonalDownAdjacent") then
			neighbors = target.parent:getSameColorLRDiagonalDownNeighbors(target, nil)
		elseif( matchingMode == "LRDiagonalUpAdjacent") then
			neighbors = target.parent:getSameColorLRDiagonalUpNeighbors(target, nil)
		else
			neighbors = target.parent:getAllConnectedSameColor(target, nil)
		end

		dprint(1, "This tile has " .. #neighbors-1 .. " matching neighboring blocks")
										
		return true

	elseif(event.phase == "ended" or event.phase == "cancelled") then
		local neighbors
		if( matchingMode == "allAdjacent") then
			neighbors = target.parent:getAllConnectedSameColor(target, nil)
		elseif( matchingMode == "colAdjacent") then
			neighbors = target.parent:getSameColorColNeighbors(target, nil)
		elseif( matchingMode == "rowAdjacent") then
			neighbors = target.parent:getSameColorRowNeighbors(target, nil)
		elseif( matchingMode == "LRDiagonalDownAdjacent") then
			neighbors = target.parent:getSameColorLRDiagonalDownNeighbors(target, nil)
		elseif( matchingMode == "LRDiagonalUpAdjacent") then
			neighbors = target.parent:getSameColorLRDiagonalUpNeighbors(target, nil)
		else
			neighbors = target.parent:getAllConnectedSameColor(target, nil)
		end

		local lastColor = nil					
		for i = 1, #neighbors do
			local neighbor = neighbors[i]
			lastColor = neighbor:randomizeColor( lastColor )

						
		end

		local scoreIncr = 0
		for i = 1, #neighbors do
			scoreIncr = scoreIncr + 10 * i
		end
		scoreHUD:increment(scoreIncr)

		return true

	elseif(event.phase == "moved") then
		return true
	end
end

-- Swap Gems (Any Adjacent) Touch handler
touch_swap = function(self, event)
	local target  = event.target
	local eventID = event.id
	local parent  = target.parent

	if(event.phase == "began") then
		dprint(1, "Touched a tile with color: " .. colorNames[target.color])
		dprint(2, target.gx, target.gy)
		return true

	elseif(event.phase == "ended" or event.phase == "cancelled") then
		if(parent.lastTouchedBlock) then
			dprint(1, "Second swap tile")

			if(parent.lastTouchedBlock ~= target) then
				dprint(1, "Blocks are different")
				local dx = target.gx - parent.lastTouchedBlock.gx
				local dy = target.gy - parent.lastTouchedBlock.gy
				local ax = math.abs( dx )
				local ay = math.abs( dy )
							
				if( ax < 2 and ay < 2 ) then
					dprint(1, "Blocks are adjacent ",dx,dy)
					local tmpColor = target.color
								
					target.color                  = parent.lastTouchedBlock.color
					parent.lastTouchedBlock.color = tmpColor

					target:setFillColor( unpack(target.color) )
					parent.lastTouchedBlock:setFillColor( unpack(parent.lastTouchedBlock.color) )
				else
					dprint(1, "Blocks are NOT adjacent ",dx,dy)
				end
			else
				dprint(1, "Blocks are same tile")

			end

			parent.lastTouchedBlock = nil

		else
			dprint(1, "First swap tile")
			parent.lastTouchedBlock = target
		end

		return true
	end
end



return gameLogic