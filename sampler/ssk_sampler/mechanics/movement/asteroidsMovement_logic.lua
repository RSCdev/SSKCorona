-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Movement - 'like' Asteroids
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

local startThrust
local stopThrust
local turnLeft
local turnRight
local stopTurn

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
	layers = ssk.display.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background and overlay
	backImage = ssk.display.backImage( layers.background, "protoBack.png") 
	overlayImage = ssk.display.backImage( layers.interfaces, "protoOverlay.png") 
	overlayImage.isVisible = true

	-- Add generic direction and input buttons
	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "leftButton", screenLeft-30, screenBot-75, 42, 42, "", stopTurn, {onPress=turnLeft} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "rightButton", screenLeft-30, screenBot-25, 42, 42, "", stopTurn, {onPress=turnRight} )
	-- Universal Buttons
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight+30, screenBot-75, 42, 42, "", stopThrust, {onPress=startThrust} )
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight+30, screenBot-25, 42, 42, "", onB )

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

createPlayer = function ( x, y, size )
	local player  = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size, myName = "thePlayer" },
		{ linearDamping=0.45, isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	-- Initialize Rotate and Thrust values
	player.rotateRate      = 0
	player.thrustMagnitude = 0

	-- Create a timer event that is called ever 16 ms to
	-- rotate and/or thrust the player
	--
	-- Note: By attaching the timer listener to the player object, we 
	-- get a free event cancellation if the player object is removed or
	-- destroyed.
	player.timer = function( self, event )
		if(not self.x) then return end 
		
		-- 1. Rotate if set
		if(player.rotateRate ~= 0) then
			player.rotation = player.rotation + player.rotateRate
		end

		-- 2. Thrust if set
		if(player.thrustMagnitude ~= 0) then
			local vx,vy  = ssk.math2d.angle2Vector( player.rotation )
			local vx,vy  = ssk.math2d.scale( vx,vy, player.thrustMagnitude )
	
			player:applyForce( vx, vy, player.x, player.y )
		end
	end

	timer.performWithDelay( 16, player, 0 ) -- repeat every 16 ms, forever

	function player:setRotateRate( rotateRate )
		player.rotateRate = rotateRate
	end

	function player:setThrustMagnitude( thrustMagnitude )
		player.thrustMagnitude = thrustMagnitude
	end

	return player

end

createSky = function ( x, y, width, height  )
	local sky  = ssk.display.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

createTrigger = function ( contentLayer, x, y, width, height, myName  )
	local fill = _GREEN_

	local aTrigger  = ssk.display.rect( contentLayer, x, y,
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
startThrust = function ( event )
	thePlayer:setThrustMagnitude(3)
end

stopThrust = function ( event )
	thePlayer:setThrustMagnitude(0)
end

turnLeft = function ( event )
	thePlayer:setRotateRate(-3)
end

turnRight = function ( event )
	thePlayer:setRotateRate(3)
end

stopTurn = function ( event )
	thePlayer:setRotateRate(0)
end

onA = function ( event )
end

onB = function ( event )	
	thePlayer:setLinearVelocity(0,0)
	thePlayer.angularVelocity = 0
	thePlayer.rotation = 0
	thePlayer.x = centerX
	thePlayer.y = centerY
end


return gameLogic