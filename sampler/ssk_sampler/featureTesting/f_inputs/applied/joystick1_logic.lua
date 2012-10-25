-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Joystick Applied Test
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
local backImage
local thePlayer

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createCollisionCalculator
local createLayers
local addInterfaceElements

local createTrigger
local createPlayer

local joystickCB
local triggerCallback

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
	local shipSize = 40
	local wrapTrigger

	wrapTrigger = createTrigger( centerX, centerY,  
								screenWidth + 0.6 * shipSize, 
								screenHeight + 0.6 * shipSize, 
								"theWrapTrigger" )
	wrapTrigger.isVisible = false
	
	thePlayer = createPlayer( centerX, centerY, shipSize )

	ssk.gem:add( "myJoystickEvent", joystickCB )
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

	-- 3. Do gems cleanup
	ssk.gem:remove( "myJoystickEvent", joystickCB )
	--ssk.gem:removeAll() -- Could do this too, but this remove all non-grouped GEMS
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
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 

	ssk.inputs:createVirtualJoystick( centerX, centerY, 60, 25, 20, 
										"myJoystickEvent", backImage, screenGroup )
end	

createTrigger = function ( x, y, width, height, myName  )
	local aTrigger  = ssk.display.rect( layers.content, x, y,
		{ fill = _GREEN_, width = width, height = height  },
		{ isSensor=true, colliderName = "wrapTrigger", calculator= myCC  }, 
		{ 
			{"onCollisionEnded_ExecuteCallback", { callback = triggerCallback } },
		} )
	aTrigger.alpha = 0.1
	return aTrigger
end

triggerCallback = function( theTrigger, theCollider, event )
	local triggerName  = theTrigger.myName or "trigger"
	local colliderName = theCollider.myName or "collider"

	dprint(2, triggerName,colliderName)
	dprint(2, colliderName .. " exited wrapTrigger @ < " .. theCollider.x .. " , " .. theCollider.y .. " >" )
	
	local myclosure = function() ssk.component.calculateWrapPoint( theCollider, theTrigger ) end			
	timer.performWithDelay( 1, myclosure) 

	return false
end

function createPlayer( x, y, size )
	local player = ssk.display.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone3.png",
										{ size = size },
										{ isFixedRotation = false, friction = 0.0, bounce = 0.0,
										linearDamping=0.45, colliderName = "player", calculator= myCC } )

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

	function player:setThrustMagnitude( thrustMagnitude )
		player.thrustMagnitude = thrustMagnitude
	end

	return player
end

joystickCB = function ( event )
	if(event.percent > 0 ) then
		thePlayer.thrustMagnitude = 9 * event.percent/100
		thePlayer.rotation = event.angle
	else
		thePlayer.thrustMagnitude = 0
	end
end

return gameLogic