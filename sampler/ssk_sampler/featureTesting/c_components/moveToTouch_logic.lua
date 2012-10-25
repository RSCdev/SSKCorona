-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Move To Touch
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

local createBeetleShip

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
	thePlayer = createBeetleShip( centerX, centerY, layers.content, backImage )
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
	-- Add background 
	backImage = ssk.display.backImage( layers.background, "starBack_380_570.png") 
end	

createBeetleShip = function ( x, y, contentLayer, inputObj )
	local aShip  = ssk.display.imageRect( contentLayer, x, y, imagesDir .. "Lost Garden/SpaceCute/beetleship.png",
		{ width = 120, height = 120 },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC },
		{ {"mover_moveToTouch", {inputObj=inputObj} }, } )
	return aShip
end


return gameLogic