-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Something Green - Prototype #1
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
local myCC   -- Local reference to collisions Calculator
local layers -- Local reference to display layers 
local overlayImage 
local backImage

local thePlayer

-- Fake Screen Parameters (smaller than actual screen so we can see what is happening offscreen)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Callbacks/Functions
local onShowHide

local gameLogic = {}

-- ==
--   Demo/Sample Buiders Etc.
-- ==

-- =======================
-- ====================== GRID BLOCKS
-- =======================
function createGridBlock( x, y, size, contentLayer )
	local obj  = ssk.proto.rect( contentLayer, x, y,
		{ size = size-2, fill = _TRANSPARENT_, stroke = _DARKGREY_, strokeWidth = 1 } )
	obj.alpha = 0.5 
	return obj
end

-- =======================
-- ====================== NORMAL BLOCKS (NO RESPONSE)
-- =======================
function createNormalBlock( x, y, size, contentLayer )
	local obj  = ssk.proto.rect( contentLayer, x, y,
		{ size = size-2, fill = _TRANSPARENT_, stroke = _BLUE_, strokeWidth = 2 },
		{ bodyType = "static", bounce = 0.0, friction = 0.0, isFixedRotation = true, colliderName = "block", calculator= myCC } ) 
	return obj
end

-- =======================
-- ====================== JUMP BLOCKS 
-- =======================
function createJumpBlock( x, y, size, contentLayer )
	local obj  = ssk.proto.rect( contentLayer, x, y,
		{ size = size-2, fill = _TRANSPARENT_, stroke = _YELLOW_, strokeWidth = 2},
		{ bodyType = "static", bounce = 0.0, friction = 0.0, isFixedRotation = true, colliderName = "jumpblock", calculator= myCC } ) 
	return obj
end


-- =======================
-- ====================== BOUNCE BLOCKS
-- =======================
function createBounceBlock( x, y, size, contentLayer )
	local obj  = ssk.proto.rect( contentLayer, x, y,
		{ size = size-2, fill = _TRANSPARENT_, stroke = _GREEN_, strokeWidth = 2},
		{ bodyType = "static", bounce = 0.0, friction = 0.0, isFixedRotation = true, colliderName = "bounceblock", calculator= myCC } ) 
	return obj
end

-- =======================
-- ====================== KILL BLOCKS
-- =======================
function createKillBlock( x, y, size, contentLayer )
	local obj  = ssk.proto.imageRect( contentLayer, x, y,imagesDir .. "redTriangle2.png",
		{ size = size, },
		{ bodyType = "static", bounce = 0.0, friction = 0.0, isFixedRotation = true, colliderName = "killblock", calculator= myCC } ) 
	return obj
end

-- =======================
-- ====================== PLAYER (CIRCLE)
-- =======================
function myCollisionHandler( event )
	local target = event.target
	local other  = event.other

	local colliderName = other:getColliderName()

	print( target:getColliderName() .. " collided with " .. colliderName )

	if(other.myName == "block") then
		-- Nothing

	elseif(other.myName == "killblock") then
		target:removeSelf()

	elseif(other.myName == "bounceblock") then
		local vx,vy = target:getLinearVelocity()
		target:setLinearVelocity( -vx, vy )

	elseif(other.myName == "jumpblock") then
		local vx,vy = target:getLinearVelocity()
		target:setLinearVelocity( 0, 0 )

	end

	return true
end

function createPlayer( x, y, radius, contentLayer  )
	local obj  = ssk.proto.circle( contentLayer, x, y,
		{ radius = radius, myName = "thePlayer", fill = _YELLOW_, },
		{ bounce = 0.0, friction = 0.0, isFixedRotation = true, colliderName = "player", calculator= myCC }, 
		{ 
			{"onCollision_ExecuteCallback", { callback = myCollisionHandler } },
		} )

	obj.timer = function() obj:setLinearVelocity(100,0) end
	timer.performWithDelay( 500, obj )
	
	return obj
end

-- =======================
-- ====================== SKY
-- =======================
function createSky( x, y, width, height, contentLayer  )
	local sky  = ssk.proto.imageRect( contentLayer, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

-- =======================
-- ====================== PLACER
-- =======================
function placer( level_array )
	local blockSize = 32
	for row = 1, #level_array do
		local aRow = level_array[row]
		for col = 1, #aRow do
			local entry = aRow[col]
			local x = -blockSize/2 + col * blockSize
			local y = -blockSize/2 + row * blockSize

			if( entry == "p" ) then 
				createPlayer(x,y,blockSize/2 - 2 ,layers.contents)

			elseif( entry == "n" ) then 
				createNormalBlock(x,y,blockSize,layers.contents)

			elseif( entry == "b" ) then 
				createBounceBlock(x,y,blockSize,layers.contents)

			elseif( entry == "g" ) then 
				createGridBlock(x,y,blockSize,layers.contents)

			elseif( entry == "k" ) then 
				createKillBlock(x,y,blockSize,layers.contents)

			elseif( entry == "j" ) then 
				createJumpBlock(x,y,blockSize,layers.contents)
			end
		end
	end
end

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("player")      -- Yellow circle
	myCC:addName("block")  -- Just collides, no response
	myCC:addName("bounceblock") -- Blue; causes player direction to change on collision
	myCC:addName("jumpblock")   -- Orange; Causes player to 'jump' up one block and continue in same direction
	myCC:addName("killblock")   -- Kills player

	myCC:collidesWith("player", "block", "bounceblock", "jumpblock", "killblock")
	myCC:dump()

	-- 2. Set up any rendering layers we need
	layers = ssk.proto.quickLayers( screenGroup, 
		"background", 
		"contents",
		"interfaces" )

	-- 3. Add a background
	backImage = ssk.proto.backImage( layers.background, "starBack_380_570.png") 

	-- 4. Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	--ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
	
	-- 5. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,9.8)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 6. Add demo/sample content
	local backgrid = 
	{
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
		{"g","g","g","g","g","g","g","g","g","g","g","g","g","g","g"},
	}
	placer( backgrid )


	local testLevel = 
	{
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","b","p","_","_","j","_","_","_","_","_","_","_","_","_"},
		{"_","n","n","n","n","n","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"_","_","_","_","_","_","_","_","_","_","_","_","_","_","_"},
		{"k","k","k","k","k","k","k","k","k","k","k","k","k","k","k"},
	}
	placer( testLevel )



--	ssk.gem:add("myHorizSnapEvent", joystickListener)
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers = nil
	myCC = nil

	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
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


return gameLogic