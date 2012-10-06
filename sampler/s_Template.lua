-- =============================================================
-- s_Template.lua 
-- Scene Template
-- =============================================================
-- Last Modified: 23 JUL 2012
-- =============================================================
local storyboard = require( "storyboard" )
local scene      = storyboard.newScene()
local trash      = ssk.trash:newCan()

----------------------------------------------------------------------
--								LOCALS								--
----------------------------------------------------------------------
-- Variables
local screenGroup

-- Callbacks/Function Declarations

----------------------------------------------------------------------
-- Scene Methods:
-- scene:createScene( event )    - Called when the scene's view does not exist
-- scene:willEnterScene( event ) - Called BEFORE scene has moved onscreen
-- scene:enterScene( event )     - Called immediately after scene has moved onscreen
-- scene:exitScene( event )      - Called when scene is about to move offscreen
-- scene:didExitScene( event )   - Called AFTER scene has finished moving offscreen
-- scene:destroyScene( event )   - Called prior to the removal of scene's "view" (display group)
-- scene:overlayBegan( event )   - Called if/when overlay scene is displayed via storyboard.showOverlay()
-- scene:overlayEnded( event )   - Called if/when overlay scene is hidden/removed via storyboard.hideOverlay()
----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:createScene( event )
	screenGroup = self.view
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
	trash:empty()	
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


-------------------------------------------------------------------------------
-- Scene Dispatch Events, Etc.
-------------------------------------------------------------------------------
scene:addEventListener( "createScene", scene )
scene:addEventListener( "willEnterScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "didExitScene", scene )
scene:addEventListener( "destroyScene", scene )
scene:addEventListener( "overlayBegan", scene )
scene:addEventListener( "overlayEnded", scene )
-------------------------------------------------------------------------------
return scene
