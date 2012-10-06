-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- SSK Sampler Main Menu
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

local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup
local backImage 
local currentPlayerNameLabel

-- Callbacks/Functions
local onPlay
local onCredits
local onOptions
local onHelp

----------------------------------------------------------------------
--	Scene Methods:
-- scene:createScene( event )  - Called when the scene's view does not exist
-- scene:willEnterScene( event ) -- Called BEFORE scene has moved onscreen
-- scene:enterScene( event )   - Called immediately after scene has moved onscreen
-- scene:exitScene( event )    - Called when scene is about to move offscreen
-- scene:didExitScene( event ) - Called AFTER scene has finished moving offscreen
-- scene:destroyScene( event ) - Called prior to the removal of scene's "view" (display group)
-- scene:overlayBegan( event ) - Called if/when overlay scene is displayed via storyboard.showOverlay()
-- scene:overlayEnded( event ) - Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
----------------------------------------------------------------------
function scene:createScene( event )
	screenGroup = self.view
	if(system.orientation == "portrait") then		
		backImage   = ssk.proto.backImage( screenGroup, "RGSplash2_Portrait.jpg", true ) 
	elseif(system.orientation == "landscapeRight") then
		backImage   = ssk.proto.backImage( screenGroup, "RGSplash2_Landscape.jpg", true ) 
	end


	local tmpButton
	local tmpTxt

	-- Game Title
	tmpTxt = ssk.labels:presetLabel( screenGroup, "headerLabel", "Main Menu", centerX, 30, { fontSize = 32 } )

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY

	--
	-- PLAY 
	--
	curY = centerY - 75
	categoryButton = ssk.buttons:presetPush( screenGroup, "greenGradient", centerX, curY, 200, 40,  "Play", onPlay )

	--
	-- OPTIONS
	--
	curY = centerY - 25
	categoryButton = ssk.buttons:presetPush( screenGroup, "yellowGradient", centerX, curY, 200, 40,  "Options", onOptions ) 

	--
	-- CREDITS
	--
	curY = centerY + 25
	categoryButton = ssk.buttons:presetPush( screenGroup, "orangeGradient", centerX, curY, 200, 40,  "Credits", onCredits ) 
	
	--
	-- HELP
	--
	curY = centerY + 75
	categoryButton = ssk.buttons:presetPush( screenGroup, "whiteGradient", centerX, curY, 200, 40,  "Help", onHelp ) 

	--
	-- RG Button
	--
	ssk.buttons:presetPush( screenGroup, "RGButton", 30, h-30, 40, 40, "", onRG  )

	--
	-- Version Label
	--
	tmpTxt = ssk.labels:presetLabel( screenGroup, "centeredLabel", "Last Modified: " .. releaseDate, centerX, h-20, { textColor = _WHITE_ } )

	--
	-- Corona Badge/Button
	--
	ssk.buttons:presetPush( screenGroup, "CoronaButton", w-30, h-30, 50, 48, "", onRG  )

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:enterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:exitScene( event )
	screenGroup = self.view	
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:didExitScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:destroyScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayBegan( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:overlayEnded( event )
	screenGroup = self.view
	local overlay_name = event.sceneName  -- name of the overlay scene
end

----------------------------------------------------------------------
--				FUNCTION/CALLBACK DEFINITIONS						--
----------------------------------------------------------------------
onPlay = function ( event ) 
	local options =
	{
		effect = "slideLeft",
		time = 400,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_PlayGUI", options  )	

	return true
end

onOptions = function ( event ) 
	local options =
	{
		effect = "zoomInOutFade",
		time = 400,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Options", options  )	

	return true
end

onCredits = function ( event ) 
	local options =
	{
		effect = "crossFade",
		time = 400,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Credits", options  )	

	return true
end

onHelp = function ( event ) 
	local options =
	{
		effect = "flip",
		time = 250,
		params =
		{
			logicSource = nil
		}
	}

	storyboard.gotoScene( "s_Help", options  )	

	return true
end



---------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc. - Generally Do Not Touch Below This Line
---------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan", scene )
scene:addEventListener( "overlayEnded", scene )
---------------------------------------------------------------------------------

return scene
