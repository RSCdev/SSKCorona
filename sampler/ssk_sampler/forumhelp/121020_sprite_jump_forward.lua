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
-- Last Modified: 29 AUG 2012
-- =============================================================

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage
local myFrog
local jumpTime = 600

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

local createSprite


local onB

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
	createSprite( screenLeft + 15 , screenBot - 10, 0.5 )
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	myFrog = nil

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
	backImage = ssk.proto.backImage( layers.background, "backImage.jpg") 
	overlayImage = ssk.proto.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	-- Add generic direction and input buttons
	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

end	

function createSprite( x, y, scale ) 

	local oldStyleSpriteSheetData = require( "images.misc.animFrog.frog").getSpriteSheetData()

	local options =
	{
		spriteSheetFrames = oldStyleSpriteSheetData.frames
	}

	local imageSheet = graphics.newImageSheet( imagesDir .. "misc/animFrog/frog.png", options )

	local frogSequenceData = {
		{ 
			name = "normalRun",  --name of animation sequence
			start = 1,
			count = 6,
			time = jumpTime,  --optional, in milliseconds; if not supplied, the sprite is frame-based
			loopCount = 1,  --optional. 0 (default) repeats forever; a positive integer specifies the number of loops
			loopDirection = "forward"  --optional, either "forward" (default) or "bounce" which will play forward then backwards through the sequence of frames
		}  --if defining more sequences, place a comma here and proceed to the next sequence sub-table	
	}

	myFrog = display.newSprite( imageSheet, frogSequenceData )
	myFrog.x = x
	myFrog.y = y
	myFrog.initialX = x
	myFrog.initialY = y
	myFrog:scale(scale,scale)

	layers.content:insert( myFrog )

	myFrog.touch = function( self, event )
		if(event.phase == "ended" or event.phase == "cancelled") then
			if( myFrog.x < (screenRight - 50) ) then
				myFrog:play()
				transition.to( myFrog, {x = myFrog.x + 40, time = jumpTime-100, transition = transition.linear })
			end
		end
	end

	myFrog:addEventListener( "touch", myFrog ) 


end

-- Movement/General Button Handlers
onB = function ( event )	
	myFrog.x = myFrog.initialX
	myFrog.y = myFrog.initialY
end


return gameLogic