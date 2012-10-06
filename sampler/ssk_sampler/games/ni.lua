-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Ichi Clone Prototype (incomplete)
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

local trash = ssk.trash:newCan()

-- Fake Screen Parameters (smaller than actual screen so we can see what is happening offscreen)
local screenWidth  = 320
local screenHeight = 240
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
-- ================================ 
-- ================================ THE BALL
-- ================================ 

function createBall( x, y, radius, contentLayer, trash )

	local obj = ssk.proto.circle( contentLayer, x, y, 
		{ fill = _YELLOW_, stroke = _BRIGHTORANGE_, strokeWidth = 2, radius = radius, myName = "theBall" },
		{ isFixedRotation = true, bounce=1.0,  friction=0.0, calculator= myCC, colliderName = "ball"} )


	obj:setLinearVelocity(0,125)


	trash:add(obj)
	return obj
end


function createPaddle( x, y, size, contentLayer, trash )

	local halfSize = size/2
	local triangleShape = { halfSize, -halfSize, halfSize, halfSize, -halfSize, halfSize }


	local obj = ssk.proto.imageRect( contentLayer, x, y, imagesDir .. "redTriangle.png",
		{ size = size, myName = "aPaddle" },
		{ bodyType = "kinematic", isFixedRotation = true, bounce=1.0, friction=0.0, 
		  calculator= myCC, colliderName = "paddle", shape = triangleShape} )

	trash:add(obj)
	return obj

end

function createBlock( x, y, size, contentLayer, trash)

	local block  = ssk.proto.rect( contentLayer, x, y,
		{ fill = _YELLOW_, size = size, myName = "aBlock" },
		{ bodyType = "kinematic", isFixedRotation = true, bounce=1.0, friction=0.0, 
		  calculator= myCC, colliderName = "block"} )

	block:setLinearVelocity( tunnelSpeed, 0)
	trash:add(block)
	return block
end


-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Create collisions calculator and set up collision matrix
	myCC = ssk.ccmgr:newCalculator()
	myCC:addName("ball")
	myCC:addName("paddle")
	myCC:addName("block")
	myCC:addName("wall")
	myCC:addName("exit")
	myCC:collidesWith("ball", "paddle", "block", "wall", "exit")
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
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 6. Add demo/sample content
	local radius = 4
	local offset = math.sqrt(2) * radius/2
	createBall( centerX, centerY, radius, layers.contents, trash)

	local paddle
	paddle = createPaddle( 240+offset, 240+offset, 40, layers.contents, trash)
	
	paddle = createPaddle( 80-offset, 240+offset, 40, layers.contents, trash)
	paddle.rotation = 90
	
	--createBlock( 80, 240, 40, layers.contents, trash)
	
	paddle = createPaddle( 80-offset, 80-offset, 40, layers.contents, trash)
	paddle.rotation = 180

	paddle = createPaddle( 240+offset, 80-offset, 40, layers.contents, trash)
	paddle.rotation = 270

	--createBlock( 240, 80, 40, layers.contents, trash)


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

	trash:empty()

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