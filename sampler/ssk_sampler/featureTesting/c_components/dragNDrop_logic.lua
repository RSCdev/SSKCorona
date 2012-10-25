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

local cardPile
local cardTray

local cardWidth = 80
local cardHeight = 110

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
local createCardPile
local createRandomCard
local createPlayerCardTray

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
	createPlayerCardTray(centerX, centerY + 70, layers.content)
	createCardPile( centerX, centerY - 85, layers.content )


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
	local ctw = cardTray.width
	local cth = cardTray.height

	if( math.pointInRect( dropObj.x, dropObj.y, cardTray.x - ctw/2, cardTray.y - cth/2, ctw,cth) ) then
		print("Dropped on tray")
		if(cardTray.cardCount >= 5) then
			print("Tray full")
			transition.to(dropObj, { time = 300, x = cardPile.x, y = cardPile.y } )
		else
			print("Dropping card to tray")
			local newCard = createRandomCard( dropObj.x, dropObj.y, dropObj.parent )
			dropObj.x = cardPile.x
			dropObj.y = cardPile.y

			local targetX = cardTray.x - 2 * cardWidth + cardTray.cardCount * cardWidth

			transition.to(newCard, { time = 300, x = targetX, y = cardTray.y } )

			cardTray.cardCount = cardTray.cardCount + 1

		end
	else
		transition.to(dropObj, { time = 300, x = cardPile.x, y = cardPile.y } )
	end
end

function createCardPile( x, y, contentLayer )

	cardPile  = ssk.display.imageRect( contentLayer, x, y, imagesDir .. "cards/cardback.png",
		{ width = cardWidth, height = cardHeight, myName = "theCardPile" },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC })

	local topCard  = ssk.display.imageRect( contentLayer, x, y, imagesDir .. "cards/cardback.png",
		{ width = cardWidth, height = cardHeight, myName = "theCardPile" },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC },
		{ {"mover_dragDrop", {onDrop=onDropCB} }, } )
	return topCard
end


function createRandomCard( x, y, contentLayer )

	local cardNames = { 
		"c01.png", "c02.png", "c03.png", "c04.png", "c05.png", "c06.png",
		"c07.png", "c08.png", "c09.png", "c10.png", "c11.png", "c12.png",
		"c13.png", "d01.png", "d02.png", "d03.png", "d04.png", "d05.png",
		"d06.png", "d07.png", "d08.png", "d09.png", "d10.png", "d11.png", 
		"d12.png", "d13.png", "h01.png", "h02.png", "h03.png", "h04.png",
		"h05.png", "h06.png", "h07.png", "h08.png", "h09.png", "h10.png",
		"h11.png", "h12.png", "h13.png", "s01.png", "s02.png", "s03.png",
		"s04.png", "s05.png", "s06.png", "s07.png", "s08.png", "s09.png",
		"s10.png", "s11.png", "s12.png", "s13.png",
	}

	local cardName = cardNames[math.random(1,52)]

	local aCard  = ssk.display.imageRect( contentLayer, x, y, 
	    imagesDir .. "cards/ClassicShrunk/" .. cardName,
		{ width = cardWidth, height = cardHeight, myName = "theCardPile" },
		{ isFixedRotation = true, friction = 0.0, bounce = 0.0,
		  colliderName = "player", calculator= myCC } )
	return aCard
end

-- =======================
-- ====================== Create Player Card Tray
-- =======================
function createPlayerCardTray( x, y, contentLayer  )
	cardTray  = ssk.display.rect( contentLayer, x, y,
		{ width = (cardWidth * 5) + 22 , height = cardHeight * 1.5 , myName = "thePlayerCardTray",
		  fill = _DARKGREY_, stroke = _WHITE_, strokeWidth = 2 } )
	cardTray.alpha = 0.25

	cardTray.cardCount = 0
	return cardTray
end


return gameLogic