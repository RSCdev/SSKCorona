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

local rowY
local categoryButton
local subCategoryButton
local updateSubcategoriesButton

local categoryCounter
local subCategoryCounter

-- Callbacks/Functions
local onCategory
local onSubCategory
local onGo

local onRG
local onCorona

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
	backImage   = ssk.display.backImage( screenGroup, "backImage.jpg", false ) 

	local tmpButton
	local tmpTxt

	-- Game Title
	tmpTxt = ssk.labels:presetLabel( screenGroup, "headerLabel", "SSKCorona - Sampler", centerX, 30, { fontSize = 24 } )
	tmpTxt.x = tmpTxt.x + 20
	local ts = sampleManager:getTotalSamples()
	tmpTxt = ssk.labels:presetLabel( screenGroup, "headerLabel", "( " .. ts .. " examples made with Super Starter Kit for Corona SDK)", centerX, 60, { fontSize = 16, color = {0,0,0,255} } )
	tmpTxt.x = tmpTxt.x + 40

	-- ==========================================
	-- Buttons and Labels
	-- ==========================================
	local curY

	if(system.orientation == "portrait") then		
		curY = 190		
	elseif(system.orientation == "landscapeRight") then
		curY = 130
	end
	
	--
	-- PLAY 
	--
	-- Category Button
	curY = curY + 0
	local categories = sampleManager:getCategories()
	categoryButton = ssk.buttons:presetPush( screenGroup, "whiteGradient", centerX-35, curY, 380, 40, 
		categories[1], ssk.sbc.tableRoller_CB, { fontSize = 18, textOffset = {0,1} } )
	
	ssk.sbc.prep_tableRoller( categoryButton, categories, onCategory ) 

	local ccNum = 1
	local tcNum = sampleManager:getCategoriesCount()
	categoryCounter = ssk.labels:presetLabel( screenGroup, "black", ccNum .. " of " .. tcNum , w - 45, curY, { fontSize = 16, color = {0,0,0,255} } )

	-- Subcategory Button
	curY = curY + 50
	local subCategories = sampleManager:getSubcategories( categories[1] )

	subCategoryButton = ssk.buttons:presetPush( screenGroup, "yellowGradient", centerX-35, curY, 380, 40, 
		subCategories[1], ssk.sbc.tableRoller_CB, { fontSize = 18, textOffset = {0,1} } )
	
	ssk.sbc.prep_tableRoller( subCategoryButton, subCategories, onSubCategory ) 

	local cscNum = 1
	local tscNum = sampleManager:getSubcategoriesCount( categories[1] )
	subCategoryCounter = ssk.labels:presetLabel( screenGroup, "black", cscNum .. " of " .. tscNum , w - 45, curY, { fontSize = 16, color = {0,0,0,255} } )

	-- Go Button
	curY = curY + 70
	ssk.buttons:presetPush( screenGroup, "greenGradient", centerX, curY, 80, 40, 
						"Go", onGo, { fontSize = 26, textOffset = {0,1} } )

	--
	-- RG Button
	--
	ssk.buttons:presetPush( screenGroup, "RGButton", 30, h-30, 40, 40, "", onRG  )

	--
	-- Corona Badge/Button
	--
	ssk.buttons:presetPush( screenGroup, "CoronaButton", 40, 40, 75, 72, "", onCorona  )

	--
	-- Version Label
	--
	tmpTxt = ssk.labels:presetLabel( screenGroup, "generalLabel", "Last Modified: " .. releaseDate, w-10, h-20 )

	-- Board Outline
	if(system.orientation == "portrait") then		
		local boardOutline =  display.newLine( 3,2, 318,2 )
		boardOutline:append( 318, 478, 3, 478, 3, 2)
		boardOutline:setColor( botLineColor[1],botLineColor[2],botLineColor[3],botLineColor[4] )
		boardOutline.width = 3
		screenGroup:insert(boardOutline)
		local boardOutline =  display.newLine( 3,1, 317,1 )
		boardOutline:append( 317, 477, 2, 477, 2, -1)
		boardOutline:setColor( topLineColor[1],topLineColor[2],topLineColor[3],topLineColor[4] )
		boardOutline.width = 3
		screenGroup:insert(boardOutline)
	elseif(system.orientation == "landscapeRight") then
		local boardOutline =  display.newLine( 3,2, 478,2 )
		boardOutline:append( 478, 318, 3, 318, 3, 2)
		boardOutline:setColor( botLineColor[1],botLineColor[2],botLineColor[3],botLineColor[4] )
		boardOutline.width = 3
		screenGroup:insert(boardOutline)
		local boardOutline =  display.newLine( 3,1, 477,1 )
		boardOutline:append( 477, 317, 2, 317, 2, -1)
		boardOutline:setColor( topLineColor[1],topLineColor[2],topLineColor[3],topLineColor[4] )
		boardOutline.width = 3
		screenGroup:insert(boardOutline)
	end

end

----------------------------------------------------------------------
----------------------------------------------------------------------
function scene:willEnterScene( event )
	screenGroup = self.view
end

----------------------------------------------------------------------
----------------------------------------------------------------------
local firstPass = true
function scene:enterScene( event )
	screenGroup = self.view

	if( not firstPass ) then
		local curCategory    = categoryButton:getText()
		local curSubCategory = subCategoryButton:getText()

		--local samplePath = sampleManager:getSamplePath( curCategory, curSubCategory )
		local samplePath = "generic_scene"
		dprint(2, "Purging: " .. samplePath)
		storyboard.purgeScene( samplePath )
	end

	firstPass = false


	if( enableRandomOpenCloseTesting ) then

		local options = {
			effect = "fade",
			time = 0,
			params =
			{
				logicSource = sampleManager:getRandomSamplePath(),
			}
		}

		local samplePath = "generic_scene"
		local closure = function() storyboard.gotoScene( samplePath, options  )	 end
		timer.performWithDelay(100, closure )

	elseif( enableOpenCloseTesting ) then
		timer.performWithDelay(openCloseTestingMinDelay, onGo )

	elseif( enableAutoLoad ) then
		timer.performWithDelay(openCloseTestingMinDelay, onGo )
	end

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
onCategory = function ( event ) 
	updateSubcategoriesButton()
	local ccNum = sampleManager:getCategoriesEntryNum( categoryButton:getText() )
	local tcNum = sampleManager:getCategoriesCount()
	categoryCounter:setText( ccNum .. " of " .. tcNum)

	local cscNum = sampleManager:getSubCategoriesEntryNum( categoryButton:getText(), subCategoryButton:getText() )
	local tscNum = sampleManager:getSubcategoriesCount(categoryButton:getText())
	subCategoryCounter:setText( cscNum .. " of " .. tscNum)

	return true
end

onSubCategory = function ( event ) 
	
	local cscNum = sampleManager:getSubCategoriesEntryNum( categoryButton:getText(), subCategoryButton:getText() )
	local tscNum = sampleManager:getSubcategoriesCount(categoryButton:getText())
	subCategoryCounter:setText( cscNum .. " of " .. tscNum)

	return true
end


updateSubcategoriesButton = function()
	local curCategory = categoryButton:getText()
	local subCategories = sampleManager:getSubcategories( curCategory )

	subCategoryButton:setText(subCategories[1])
	ssk.sbc.prep_tableRoller( subCategoryButton, subCategories, onSubCategory ) 

end

onGo = function ( event ) 
	local curCategory    = categoryButton:getText()
	local curSubCategory = subCategoryButton:getText()

	local options =
	{
		effect = "fade",
		time = 0,
		params =
		{
			logicSource = sampleManager:getSamplePath( curCategory, curSubCategory ),
		}
	}

	local samplePath = "generic_scene"
	storyboard.gotoScene( samplePath, options  )	
	return true
end

onRG = function(event)
	system.openURL( "http://developer.coronalabs.com/code/sskcorona"  )
	return true
end

onCorona = function(event)
	system.openURL( "http://developer.coronalabs.com/"  )
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
