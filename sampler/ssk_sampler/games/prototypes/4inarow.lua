-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Drag-n-Drop
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
-- Last Modified: 04 OCT 2012
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

local chipPile
local chipTray
local chipColumns = {}

local chipWidth   = 42
local chipHeight  = 42
local chipRows    = 5
local chipCols    = 8
local boardOffset = 30
local chipPileY   = 40
local dropPPS     = 350

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

local onDropCB
local createChipPile
local createNewChip
local createBoard

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
	createBoard(centerX, centerY + boardOffset, layers.content)
	createChipPile( centerX, chipPileY, layers.content )


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

--	ssk.gem:remove("myHorizSnapEvent", joystickListener)
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
	backImage = ssk.display.backImage( layers.background, "feltBack.png") 
end	

function onDropCB( dropObj, event )
	print("Got drop event")


	for i = 1, chipCols do
		local curTray = chipColumns[i]
		local ctw = curTray.width
		local cth = curTray.height

		if( math.pointInRect( dropObj.x, dropObj.y, curTray.x - ctw/2, curTray.y - cth/2, ctw,cth) ) then
			print("Dropped on tray " .. i)
			if(curTray.chipCount >= chipRows) then
				print("Tray " .. i .. "  full")
				transition.to(dropObj, { time = 300, x = chipPile.x, y = chipPile.y } )
			else
				print("Dropping chip to tray")
				--local newchip = createNewChip( dropObj.x, dropObj.y, dropObj.parent )

				local newchip = createNewChip( curTray.x, curTray.y - curTray.height/2 - chipHeight, dropObj.parent )
				dropObj.x = chipPile.x
				dropObj.y = chipPile.y

				local targetY = curTray.y + 2 * chipHeight - curTray.chipCount * chipHeight

				local transitionTime = ((targetY - newchip.y) / dropPPS) * 1000
				
				transition.to(newchip, { time = transitionTime, x = curTray.x, y = targetY } )

				curTray.chipCount = curTray.chipCount + 1
	
			end

			return
		end
	end

	transition.to(dropObj, { time = 300, x = chipPile.x, y = chipPile.y } )
end

function createChipPile( x, y, contentLayer )

	print("edo")
	chipPile  = ssk.display.imageRect( contentLayer, x, y, imagesDir .. "chip80.png",
		{ width = chipWidth, height = chipHeight, myName = "thechipPile" },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC })

	local topchip  = ssk.display.imageRect( contentLayer, x, y, imagesDir .. "chip80.png",
		{ width = chipWidth, height = chipHeight, myName = "thechipPile" },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC },
		{ {"mover_dragDrop", {onDrop=onDropCB} }, } )
	return topchip
end


function createNewChip( x, y, contentLayer )

	local aChip  = ssk.display.imageRect( contentLayer, x, y, 
	    imagesDir .. "chip80.png",
		{ width = chipWidth, height = chipHeight, myName = "thechipPile", fill = _ORANGE_ },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC } )

	return aChip
end

-- =======================
-- ====================== Create Places to Drop Chips
-- =======================
function createChipColumn( x, y, col, contentLayer  )
	chipColumns[col]  = ssk.display.rect( contentLayer, x, y,
		{ width = chipWidth, height = (chipHeight * chipRows) + 10 , myName = "aChipTray",
		  fill = _DARKGREY_, stroke = _WHITE_, strokeWidth = 2 } )
	chipColumns[col].alpha = 0.05

	chipColumns[col].chipCount = 0
	return chipColumns[col]
end

function createBoard( x, y, contentLayer  )
	chipTray  = ssk.display.rect( contentLayer, x, y,
		{ width = (chipWidth * chipCols) + 22 , height = (chipHeight * chipRows) + 10 , myName = "aChipTray",
		  fill = _DARKGREY_, stroke = _WHITE_, strokeWidth = 2 } )
	chipTray.alpha = 0.25

	chipTray.chipCount = 0

	local firstColumnX = x - chipTray.width/2 + 22

	for i = 0, chipCols-1 do
		createChipColumn( firstColumnX + 11 + i * chipWidth, y, i+1, contentLayer  )
	end

	return chipTray
end

return gameLogic