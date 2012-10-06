-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Movement - Linear
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
local thePlayer
local wrapTrigger

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

local createPlayer
local createSky

local createTrigger
local triggerCallback

local onShowHide

local onUp
local onDown
local onRight
local onLeft

local onStop

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
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 5. Add demo/sample content
	local shipSize = 25
	thePlayer = createPlayer( centerX, centerY, shipSize, layers.content )

	wrapTrigger = createTrigger( layers.content, centerX, centerY,  
		screenWidth + 1.0 * shipSize, screenHeight + 1.0 * shipSize, 
		"theWrapTrigger"  )
	wrapTrigger.isVisible = false

	createSky(centerX, centerY, 320, 240, layers.background)

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
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "upButton", screenLeft-30, screenBot-175, 42, 42, "", onStop, {onPress=onUp} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "downButton",  screenLeft-30, screenBot-125, 42, 42, "", onStop, {onPress=onDown} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", onStop, {onPress=onLeft} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", onStop, {onPress=onRight} )
	-- Universal Button
	--tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-75, 42, 42, "",  onA )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "",  onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

createPlayer = function ( x, y, size )
	local player  = ssk.proto.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size, myName = "thePlayer" },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.proto.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

createTrigger = function ( contentLayer, x, y, width, height, myName  )
	local fill = _GREEN_

	local aTrigger  = ssk.proto.rect( contentLayer, x, y,
		{ fill = fill, width = width, height = height, myName = myName },
		{ isSensor=true, colliderName = "wrapTrigger", calculator= myCC  }, 
		{ 
			{"onCollisionEnded_ExecuteCallback", { callback = triggerCallback } },
		} )

	aTrigger.alpha = 0.25
	return aTrigger
end

triggerCallback = function( theTrigger, theCollider, event )
	local triggerName  = theTrigger.myName or "trigger"
	local colliderName = theCollider.myName or "collider"

	dprint(2, triggerName,colliderName)
	dprint(2, colliderName .. " exited wrapTrigger @ < " .. theCollider.x .. " , " .. theCollider.y .. " >" )
	
	local myclosure = function() ssk.component.calculateWrapPoint( theCollider, theTrigger ) end			
	timer.performWithDelay( 1, myclosure) 
end




onShowHide = function ( event )
	local target = event.target
	if(event.target:getText() == "Hide Details") then
		overlayImage.isVisible = true
		wrapTrigger.isVisible = false
		event.target:setText( "Show Details" )
	else
		overlayImage.isVisible = false
		wrapTrigger.isVisible = true
		event.target:setText( "Hide Details" )
	end	
end


-- Movement/General Button Handlers
onUp = function ( event )
	thePlayer:setLinearVelocity( 0, -75 )
end

onDown = function ( event )
	thePlayer:setLinearVelocity( 0, 75 )
end

onRight = function ( event )
	thePlayer:setLinearVelocity( 75, 0 )
end

onLeft = function ( event )
	thePlayer:setLinearVelocity( -75, 0 )
end

onStop = function( event )
	thePlayer:setLinearVelocity( 0, 0 )
end

onA = function ( event )
end

onB = function ( event )	
	thePlayer.x = centerX
	thePlayer.y = centerY
end



return gameLogic