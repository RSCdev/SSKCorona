-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Virtual Joystick Test
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
local layers -- Local reference to display layers 
local backImage

local labelNames = {"vx", "vy", "nx", "ny", "percent", "phase", "state", "angle", "direction" }

-- Fake Screen Parameters (used to create visually uniform demos)
local screenWidth  = w
local screenHeight = h
local screenLeft   = centerX - screenWidth/2
local screenRight  = centerX + screenWidth/2
local screenTop    = centerY - screenHeight/2
local screenBot    = centerY + screenHeight/2

-- Local Function & Callback Declarations
local createLayers
local addInterfaceElements

local joystickListener

local gameLogic = {}

-- =======================
-- ====================== Initialization
-- =======================
function gameLogic:createScene( screenGroup )

	-- 1. Set up any rendering layers we need
	createLayers( screenGroup )

	-- 2. Add Interface Elements to this demo (buttons, etc.)
	addInterfaceElements()

	-- 3. Set up gravity and physics debug (if wanted)
	physics.setGravity(0,0)
	--physics.setDrawMode( "hybrid" )
	screenGroup.isVisible=true
	
	-- 4. Add demo/sample content
	-- Static Labels
	local curX = screenLeft + 120
	local curY = screenTop + 30

	local extraParams = { referencePoint = display.CenterRightReferencePoint, fontSize = 24, color = _WHITE_ }

	for k,v in ipairs( labelNames ) do
		local tmp = ssk.labels:presetLabel( layers.interfaces, "default", v ..":", curX , curY, extraParams )
		curY = curY + 30
	end

	-- Dynamic Labels
	curX = screenLeft + 140
	curY = screenTop + 30
	extraParams = { referencePoint = display.CenterLeftReferencePoint, fontSize = 24, color = _WHITE_ }

	for k,v in ipairs( labelNames ) do
		gameLogic[v] = ssk.labels:presetLabel( layers.interfaces, "default", "-", curX , curY, extraParams )
		gameLogic[v].origX = curX
		curY = curY + 30
	end

	ssk.gem:add("myJoystickEvent", joystickListener)

	ssk.inputs:createVirtualJoystick( centerX+140, centerY, 60, 30, 20, "myJoystickEvent", backImage, screenGroup )
end

-- =======================
-- ====================== Cleanup
-- =======================
function gameLogic:destroyScene( screenGroup )
	-- 1. Clear all references to objects we (may have) created in 'createScene()'	
	layers:destroy()
	layers = nil
	
	-- 2. Clean up gravity and physics debug
	physics.setDrawMode( "normal" )
	physics.setGravity(0,0)
	screenGroup.isVisible=false

	ssk.gem:remove("myJoystickEvent", joystickListener)
end


-- =======================
-- ====================== Local Function & Callback Definitions
-- =======================

createLayers = function( group )
	layers = ssk.proto.quickLayers( group, 
		"background", 
		"content",
		"interfaces" )
end

addInterfaceElements = function()
	-- Add background 
	backImage = ssk.proto.backImage( layers.background, "starBack_380_570.png") 
end	


joystickListener = function( event )
	for k,v in ipairs( labelNames ) do
		gameLogic[v]:setText(event[v] or "-")
		gameLogic[v]:setReferencePoint(display.CenterLeftReferencePoint)
		gameLogic[v].x = gameLogic[v].origX
	end
end

return gameLogic