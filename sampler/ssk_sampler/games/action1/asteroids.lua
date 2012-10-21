-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Horizontal Snap Input Applied Test
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
local storyboard = require( "storyboard" )

-- Variables
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local backImage
local thePlayer
local theLivesHUD

local theAsteroids = {}

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
local createAsteroid

local horizSnapCB
local triggerCallback
local startThrust
local stopThrust
local startFiring
local stopFiring

local doFire

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
								screenWidth + 0.5* shipSize, 
								screenHeight + 0.5 * shipSize, 
								"theWrapTrigger" )
	wrapTrigger.isVisible = false
	
	thePlayer = createPlayer( centerX, centerY, shipSize )

	local asteroid 
	asteroid = createAsteroid( centerX + 80, centerY, 0, 60)
	asteroid:setLinearVelocity( 30, -35 )
	theAsteroids[asteroid] = asteroid

	asteroid = createAsteroid( centerX - 80, centerY, 1, 60)
	asteroid:setLinearVelocity( -35, -25 )
	theAsteroids[asteroid] = asteroid

	asteroid = createAsteroid( centerX + 80, centerY + 80, 2, 60)
	asteroid:setLinearVelocity( 15, 45 )
	theAsteroids[asteroid] = asteroid

	ssk.gem:add( "myHorizSnapEvent", horizSnapCB )

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
	ssk.gem:remove( "myHorizSnapEvent", horizSnapCB )
	--ssk.gem:removeAll() -- Could do this too, but this remove all non-grouped GEMS

	theAsteroids = {}
end

-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================
createCollisionCalculator = function()
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")
	myCC:addName("playerBullet")
	myCC:addName("asteroid")
	myCC:addName("wrapTrigger")
	myCC:collidesWith("player", "wrapTrigger")
	myCC:collidesWith("playerBullet", "wrapTrigger")
	myCC:collidesWith("playerBullet", "asteroid")
	myCC:collidesWith("asteroid", "wrapTrigger", "playerBullet", "player")
	myCC:dump()
end

createLayers = function( group )
	layers = ssk.proto.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	backImage = ssk.proto.backImage( layers.background, "starBack_380_570.png") 

	ssk.inputs:createVirtualHorizontalSnap( centerX, centerY, 40, 160, 20, 10, 
											"myHorizSnapEvent", backImage, layers.interfaces )

	local tmpButton
	tmpButton = ssk.buttons:presetPush( layers.interfaces, "A_Button", screenRight-110, screenBot-40, 60, 60, "", 
							stopThrust, { onPress=startThrust } )
	tmpButton.alpha = 0.3

	tmpButton = ssk.buttons:presetPush( layers.interfaces, "B_Button", screenRight-40, screenBot-40, 60, 60, "", stopFiring, { onPress=startFiring })
	tmpButton.alpha = 0.3

	theLivesHUD = ssk.huds:createHorizImageCounter( layers.interfaces, 
	                                                100, 20, 
													imagesDir .. "ship.png", 20, 20, 
													10, 3)
end	

createTrigger = function ( x, y, width, height, myName  )
	local aTrigger  = ssk.proto.rect( layers.content, x, y,
		{ fill = _GREEN_, width = width, height = height, myName = "wrapTrigger"  },
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
	
	local myclosure = function() 
		if( isDisplayObject(theCollider) ) then
			ssk.component.calculateWrapPoint( theCollider, theTrigger ) 
		end
	end			
	timer.performWithDelay( 1, myclosure) 

	return false
end

function createPlayer( x, y, size )
	--local player = ssk.proto.imageRect( layers.content, x, y,imagesDir .. "DaveToulouse_ships/drone3.png",
	local player = ssk.proto.imageRect( layers.content, x, y,imagesDir .. "ship.png",
										{ size = size, myName = "thePlayer" },
										{ isSensor=true, isFixedRotation = false, friction = 0.0, bounce = 0.0,
										linearDamping=0.45, colliderName = "player", calculator= myCC, radius = size/2-4} )

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
			local vx,vy  = ssk.m2d.angle2Vector( player.rotation )
			local vx,vy  = ssk.m2d.scale( vx,vy, player.thrustMagnitude )
	
			player:applyForce( vx, vy, player.x, player.y )
		end
	end

	timer.performWithDelay( 16, player, 0 ) -- repeat every 16 ms, forever

	function player:setThrustMagnitude( thrustMagnitude )
		player.thrustMagnitude = thrustMagnitude
	end

	return player
end

function createAsteroid( x, y, asteroidNum, size )
	local asteroid = ssk.proto.imageRect( layers.content, x, y,imagesDir .. "asteroid" .. asteroidNum .. ".png",
										{ size = size, myName = "anAsteroid" },
										{ isFixedRotation = true, friction = 0.0, bounce = 1.0,
										linearDamping=0.0, colliderName = "asteroid", calculator= myCC, radius = size/2 } )

	function asteroid:collision( event )
		local target = event.target
		local other  = event.other
		local phase  = event.phase

		if(phase == "began") then
			if(other.myName == "thePlayer") then

				theLivesHUD:increment(-1)
				if( theLivesHUD:get() <= 0) then
					local closure = function() storyboard.gotoScene( "s_MainMenu" , "slideRight", 400  ) end
					timer.performWithDelay( 33, closure )
					return true
				end

				other.isVisible = false			
				local closure1 = function() 
					other.x = centerX
					other.y = centerY
					other:setLinearVelocity(0, 0)
					other.rotation = 0
					other.isBodyActive = false
				end
				timer.performWithDelay( 33, closure1 )

				local closure2
				closure2 = function() 
					local isClear = true
					for k,v in pairs(theAsteroids) do
						if math.pointInRect( v.x, v.y, centerX - 75, centerY - 75, 150, 150 ) then 
							isClear = false
						end
					end

					if(isClear) then
						other.isVisible = true 
						other.isBodyActive = true
					else 
						timer.performWithDelay( 200, closure2 )
					end
				end
				timer.performWithDelay( 2000, closure2 )

			elseif(other.myName == "aBullet") then
				target.isVisible = false

				local closure = function() 
					target.isBodyActive = false
					theAsteroids[target] = nil
					target:removeSelf()
					table.dump(target)
				end
				timer.performWithDelay( 200, closure )
			end

		end

		return true
	end

	asteroid:addEventListener( "collision", asteroid )


	return asteroid
end

horizSnapCB = function ( event )
	if(event.state == "on" and event.direction == "left") then
		thePlayer.rotateRate = -9 * event.percent/100
	elseif(event.state == "on"  and event.direction == "right") then
		thePlayer.rotateRate = 9 * event.percent/100
	else
		thePlayer.rotateRate = 0
	end
end

startThrust = function( event )
	thePlayer:setThrustMagnitude(9)
	return true
end

stopThrust = function( event )
	thePlayer:setThrustMagnitude(0)
	return true
end

doFire = function()
	if( not thePlayer.firing ) then 
		print("BANG DONE" )
		return 
	end

	-- Firing code here
	-- thePlayer
	local aBullet = ssk.proto.circle( layers.content, thePlayer.x, thePlayer.y, 
	                                  { radius = 2, myName = "aBullet" },
									  { isBullet=false, isSensor=true, isFixedRotation = false, friction = 0.0, bounce = 0.0,
									    colliderName = "playerBullet", calculator= myCC, radius = 2} )

	local tmpVec = ssk.m2do.getFacingVector( thePlayer )
	local vx,vy = thePlayer:getLinearVelocity()
	local playerVel = ssk.m2d.length(vx,vy)

	tmpVec = ssk.m2do.scale( tmpVec, 300 + playerVel)

	aBullet:setLinearVelocity( tmpVec.x, tmpVec.y )
	aBullet:toBack()

	local closure = function() aBullet:removeSelf() end
	timer.performWithDelay( 1000, closure )
	
	print("BANG" )

	thePlayer.lastFire = timer.performWithDelay( 250, doFire )
end

startFiring = function( event )
	thePlayer.firing=true
	doFire()	
	return true
end

stopFiring = function( event )
	thePlayer.firing=false

	if(thePlayer.lastFire) then 
		timer.cancel( thePlayer.lastFire )
		thePlayer.lastFire = nil
	end

	return true
end

return gameLogic