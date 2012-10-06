-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- main.lua
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
-- Last Modified: 05 AUG 2012
-- =============================================================

print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")
io.output():setvbuf("no") -- Don't use buffer for console messages

----------------------------------------------------------------------
--	1.							GLOBALS								--
----------------------------------------------------------------------
local globals = require( "ssk.globals" ) -- Load Standard Globals


----------------------------------------------------------------------
-- 2. LOAD MODULES													--
----------------------------------------------------------------------
-- STORYBOARD
local storyboard = require "storyboard"

-- PHYSICS
local physics = require("physics")
physics.start()

--physics.setGravity(0,0)
--physics.setDrawMode( "hybrid" )

-- SSK Libraries
require("ssk.loadSSK")

----------------------------------------------------------------------
-- 3. ONE-TIME INITIALIZATION										--
----------------------------------------------------------------------
-- Show device status bar?
display.setStatusBar(display.HiddenStatusBar)

-- Enable Multitouch
system.activate("multitouch")

-- set tap delay to 1/2 second to allow for double taps
system.setTapDelay(0.5)

-- Select standard font(s) (EFM move to ssk.fonts.lua or some such)
if(isTutorialDistro) then
	gameFont = native.systemFont
	helpFont = native.systemFont
 
elseif(onSimulator) then
	gameFont = "Abscissa"
	helpFont = "Courier New"

else
	gameFont = "Abscissa"
	helpFont = "Courier New"
end


-- Load Presets (Buttons, Labels, and Sounds)
--EFM local soundsInit = require("ssk.presets.sounds")
local labelsInit = require("ssk.presets.labels")
local buttonsInit = require("ssk.presets.buttons")

----------------------------------------------------------------------
-- 4. LOAD SPRITE / SET UP ANIMATIONS								--
----------------------------------------------------------------------
-- Load sprites and set up animations
--ssk.easysprites.createSpriteSet( "letterTiles", imagesDir .. "letterTiles.png", 80, 80, 54 )

----------------------------------------------------------------------
-- 6. CALCULATE COLLISION MATRIX									--
----------------------------------------------------------------------
--[[

_G.myCC = ssk.ccmgr:newCalculator()
_G.myCC:addName("player")
_G.myCC:addName("enemy")
_G.myCC:addName("playerBullet")
_G.myCC:addName("enemyBullet")
_G.myCC:collidesWith("player", "enemy", "enemyBullet")
_G.myCC:collidesWith("playerBullet", "enemy")
_G.myCC:dump()

--]]

----------------------------------------------------------------------
-- 7. LOAD AND APPLY PLAYER SPECIFIC SETTINGS						--
----------------------------------------------------------------------
--[[ EFM
-- Load name of last player (if any) or initialize default player
currentPlayer = ssk.datastore:new()
if( io.exists( "lastPlayer.txt", system.DocumentsDirectory ) ) then
	currentPlayer:load( "lastPlayer.txt" )
else
	currentPlayer:add( "name", "ThePlayer" )
	currentPlayer:add( "score", 0 )
	currentPlayer:save( "lastPlayer.txt" )
end

-- Load options for current player or initialize to defaults
ssk.gameoptions:loadPlayerOptions( currentPlayer:get("name") )

-- Setup sound levels
ssk.sounds:setEffectsVolume(0.5)
ssk.sounds:setMusicVolume(0.5)
soundVolumes.music   = ssk.gameoptions:get( "soundTrackVolume" )
soundVolumes.effects = ssk.gameoptions:get( "soundEffectsVolume" )


-- Start playing soundtrack if enabled
local newSoundTrack = ssk.gameoptions:get( "soundTrack" )
print(backgroundChannel)
audio.stop()

if(newSoundTrack == "Deliberate Thought") then
	audio.play(backgroundMusic1, { channel = backgroundChannel, loops=-1, fadein=1000})
elseif(newSoundTrack == "Finding The Balance") then
	audio.play(backgroundMusic2, { channel = backgroundChannel, loops=-1, fadein=1000})
end
audio.setVolume(soundVolumes.music , { channel=backgroundChannel } ) 
audio.setVolume(soundVolumes.effects , { channel=effectChannel } ) 

if(soundVolumes.effects == 0) then
	soundEnabled = true
else
	soundEnabled = true
end

print("soundVolumes.music == " .. soundVolumes.music )
print("soundVolumes.effects == " .. soundVolumes.effects )
--]]

--[[ EFM
-- Load list of known players
knownPlayers = ssk.datastore:new()
if( io.exists( "knownPlayers.txt", system.DocumentsDirectory ) ) then
	knownPlayers:load( "knownPlayers.txt" )
else
	-- If no players exist at all, add the current player to our list
	local playerName = currentPlayer:get( "name" )
	knownPlayers:add( playerName, playerName )
	knownPlayers:save( "knownPlayers.txt" )
end
function getKnownPlayersList()
	local tmpTable = {}
	for k,v in pairs(knownPlayers) do 
		if( ( k == v ) and ( type(v) == "string" ) ) then
			table.insert( tmpTable, v )
		end
	end
	return tmpTable
end
function saveKnownPlayersList()
	knownPlayers:save( "knownPlayers.txt" )
end
--]]


----------------------------------------------------------------------
-- 8. PRINT USEFUL DEBUG INFORMATION (BEFORE STARTING GAME)			--
----------------------------------------------------------------------
-- Print all known (loaded and useable) font names
--local sysFonts = native.getFontNames()
--for k,v in pairs(sysFonts) do print(v) end

-- Print information about the design and device resolution
ssk.misc.dumpScreenMetrics()

-- Print the collision matrix data
--collisionCalculator:dump()

--ssk.proto.listDPP()

print("\n****************************************************************")
print("*********************** /\\/\\ main.cs /\\/\\ **********************")
print("****************************************************************")
----------------------------------------------------------------------
--								LOAD FIRST SCENE					--
----------------------------------------------------------------------
storyboard.gotoScene( "s_SplashLoading" )
--storyboard.gotoScene( "s_MainMenu" )
--storyboard.gotoScene( "s_Credits" )
