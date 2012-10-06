-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Aim At Object w/ Limited distance 
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
local theSky

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
local createTurret
local createZoneMarker

local onShowHide

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
	local shipSize = 30
	local turretSize = 60
	local maxSearchRadius = 150

	local targetTable = {}
	
	theSky = createSky(centerX, centerY, 320, 240, layers.background)

	local theMarker = createZoneMarker(centerX , screenBot, maxSearchRadius, layers.content, _RED_ )

	theShip =	createPlayer( centerX, centerY + 60, shipSize, layers.content, theSky )

	targetTable[#targetTable+1] = theShip

	local theTurret = createTurret( centerX , screenBot, turretSize, layers.content, theSky )

	ssk.component.aimAtObjectMaxDist( theTurret, theShip, 16, maxSearchRadius, nil, true )
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
	theSky = nil

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

	-- Add the show/hide button for 'unveiling' hidden parts of scene/mechanics
	ssk.buttons:presetPush( layers.interfaces, "blueGradient", 64, 20 , 120, 30, "Show Details", onShowHide )
end	

function createPlayer( x, y, size, contentLayer, inputObj )
	local player  = ssk.proto.imageRect( contentLayer, x, y,imagesDir .. "DaveToulouse_ships/drone2.png",
		{ size = size,  },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC }, 
		{ {"mover_moveToTouchFixedRate", {inputObj = inputObj, moveSpeed = 150, easing = easing.linear} }, 
		  {"mover_faceTouchFixedRate", {inputObj = inputObj, aimSpeed = 0, easing = easing.linear} },
		} )
		
	return player
end

createSky = function ( x, y, width, height  )
	local sky  = ssk.proto.imageRect( layers.background, x, y, imagesDir .. "starBack_320_240.png",
		{ width = width, height = height, myName = "theSky" } )
	return sky
end

createZoneMarker = function ( x, y, radius, contentLayer, color  )
	zoneMarker  = ssk.proto.circle( contentLayer, x, y, 
		{ radius = radius, myName = "thePlayerzoneMarker",
		  fill = color, stroke = _WHITE_, strokeWidth = 2 } )
	zoneMarker.alpha = 0.20

	zoneMarker.cardCount = 0
	return zoneMarker
end


createTurret = function ( x, y, size, contentLayer, inputObj )
	local turret  = ssk.proto.imageRect( contentLayer, x, y,imagesDir .. "simpleTurret.png",
		{ size = size,  },
		{ isFixedRotation = false,  colliderName = "player", calculator= myCC } ) 
	return turret
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