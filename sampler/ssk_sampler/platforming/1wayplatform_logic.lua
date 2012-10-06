-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- 1-Way Platforms
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
-- Last Modified: 05 OCT 2012
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
local thePlayer

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

local createGround
local createPlayer
local createPlatform
local createSky

local onCollision
local onPreCollision

local onShowHide

local onA
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
	physics.setGravity(0,10)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	local playerSize = 30
	createSky(centerX, centerY, screenWidth, screenHeight )

	createPlatform( centerX, centerY+40, 60, 10 )
	createPlatform( centerX, centerY-30, 60, 10 )

	thePlayer = createPlayer( centerX, centerY, playerSize )

	createGround()
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	myCC = nil
	thePlayer = nil

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
	myCC:addName("ground")
	myCC:addName("platform")
	myCC:collidesWith("player", "ground", "platform")
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

	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-75, 42, 42, "", onA )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

createGround = function()
	local width = screenWidth/ 10
	for i = 1, 10 do
		local tmpBlock
		local tmpBlock = ssk.proto.rect( layers.content, screenLeft - width/2 + i * width, screenBot-10,
			{ width = width, height = 20, fill = _GREEN_, stroke = _WHITE_, strokeWidth = 2,
			  size = size, myName = "aGroundBlock", } ,
			{ isFixedRotation = false, friction = 1.0, bounce = 0.0, 
			  linearDamping=0.45, bodyType = "static",
			  colliderName = "ground", calculator= myCC } )
		--tmpBlock.alpha = 0.75 
		tmpBlock:toFront()
	end

end

createPlayer = function ( x, y, size )
	player  = ssk.proto.rect( layers.content, centerX, screenBot-20-size, 
		{ size = size, myName = "thePlayer", fill = _BLUE_, stroke = _WHITE_, strokeWidth = 2, },
		{ isFixedRotation = false, friction = 1.0, bounce = 0.0, 
		  linearDamping=0.45, bodyType = "dynamic",
		  colliderName = "player", calculator= myCC } )
	return player
end

createPlatform = function ( x, y, width, height )
	local platform  = ssk.proto.rect( layers.content, x, y, 
		{ width = width, height = height, myName = "aPlatform", fill = _YELLOW_, stroke = _WHITE_, strokeWidth = 2, },
		{ isFixedRotation = false, friction = 0.0, bounce = 0.0, 
		  linearDamping=0.45, bodyType = "static", 
		  colliderName = "platform", calculator= myCC } )

	platform.collision = onCollision
	platform.preCollision = onPreCollision

	platform:addEventListener( "preCollision", platform )
	platform:addEventListener( "collision", platform )

	return platform
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.proto.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

onCollision = function ( self, event )
	if(event.phase == "ended") then
		event.target.isSensor = false
	end
	return true
end

onPreCollision = function ( self, event )
	-- Note: This is simple in the sense that the center of objects are used.
	-- To make this more exact, calculate foot/head positions and use them
	-- instead.  This will help handle case where the player is collding from 
	-- the side while rising/falling.
	--
	if(event.target.y < event.other.y) then
		event.target.isSensor = true
	else 
		event.target.isSensor = false
	end
	return true
end


onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		event.target:setText( "Hide Details" )
	end	
end


-- Movement/General Button Handlers
onA = function (event )
	thePlayer.y = screenBot-20-thePlayer.height
end

onB = function (event )
	thePlayer:applyLinearImpulse( 0, -10, thePlayer.x, thePlayer.y )
end


return gameLogic