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
-- Last Modified: 29 AUG 2012
-- =============================================================

print("\n\n\n****************************************************************")
print("*********************** \\/\\/ main.cs \\/\\/ **********************")
print("****************************************************************\n\n")
io.output():setvbuf("no") -- Don't use buffer for console messages

----------------------------------------------------------------------
--	1.							GLOBALS								--
----------------------------------------------------------------------
local globals = require( "ssk.globals" ) -- Load Standard Globals

-- ================= OPEN CLOSE TESTING (BEGIN)
-- Note: This section is specific to the sampler and enables some basic testing/debugging.
-- Depending on the settings selected below, the sampler will automatically open (and
-- optionally close then reopen) one or more of the examples.  It will do this based
-- on the settings and timings provided below.  The ultimate goal of this is to find bugs
-- in the libraries and examples which often expose themselves as open-close-purge-reload
-- corner cases.
--
openCloseTestingMinDelay = 66 -- 250
openCloseTestingMaxDelay = 67 -- 1500

-- Automatically open-close-open-... first example in list
enableOpenCloseTesting = true
enableOpenCloseTesting = false

-- Automatically open-close-open-... random example in list
enableRandomOpenCloseTesting = true
enableRandomOpenCloseTesting = false

-- Automatically open first example in list (useful while editing that sample)
-- Above settings take precedence
enableAutoLoad = true
enableAutoLoad = false
-- ================= OPEN CLOSE TESTING (END)

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

-- Game Specific Modules
sampleManager = require("sampleMgr")

--
-- EFM - 'Register' SSK Samples
--
--sampleManager:addSample("Template", "Template 1", "ssk_sampler._templates.template1_logic" )
--sampleManager:addSample("Template", "Template 2", "ssk_sampler._templates.template2_logic" )

--In Progress

-- Finished
-- Inputs
sampleManager:addSample("Inputs", "Joystick (Normal)", "ssk_sampler.inputs.joystick1_logic" )
sampleManager:addSample("Inputs", "Horizontal Snap (Normal)", "ssk_sampler.inputs.horizSnap1_logic" )
sampleManager:addSample("Inputs", "Vertical Snap (Normal)", "ssk_sampler.inputs.vertSnap1_logic" )

sampleManager:addSample("Inputs", "Joystick (Virtual)", "ssk_sampler.inputs.joystick2_logic" )
sampleManager:addSample("Inputs", "Horizontal Snap (Virtual)", "ssk_sampler.inputs.horizSnap2_logic" )
sampleManager:addSample("Inputs", "Vertical Snap (Virtual)", "ssk_sampler.inputs.vertSnap2_logic" )

-- Inputs Applied
sampleManager:addSample("Inputs Applied", "Horizontal Snap", "ssk_sampler.inputs_applied.horizSnap1_logic" )
sampleManager:addSample("Inputs Applied", "Joystick", "ssk_sampler.inputs_applied.joystick1_logic" )

-- Camera
sampleManager:addSample("Camera", "#1 - Wrapping", "ssk_sampler.camera.wrapping1_logic" )
sampleManager:addSample("Camera", "#1 - 3 Layer (random objects; fixed Rate)", "ssk_sampler.camera.scrolling1_logic" )
sampleManager:addSample("Camera", "Left-Right Auto-Scroll", "ssk_sampler.camera.lrautoscroll_logic" )
sampleManager:addSample("Camera", "Legend of Zelda Auto-Scroll", "ssk_sampler.camera.zeldascroll_logic" )

-- Movement
sampleManager:addSample("Movement", "Linear Movement (L/R/U/D; Buttons)", "ssk_sampler.movement.linearMovement_logic" )
sampleManager:addSample("Movement", "Step Movement (no Repeat; Buttons)", "ssk_sampler.movement.stepNoRepeatMovement_logic" )
sampleManager:addSample("Movement", "Step Movement (w/ Repeat; Buttons)", "ssk_sampler.movement.stepwRepeatMovement_logic" )
sampleManager:addSample("Movement", "Thrust Movement (L/R/U/D; Buttons)", "ssk_sampler.movement.thrustMovement_logic" )
sampleManager:addSample("Movement", "Asteroids Movement (Buttons)", "ssk_sampler.movement.asteroidsMovement_logic" )


--Touch
sampleManager:addSample("Touch", "Drag-n-Drop", "ssk_sampler.touch.dragNDrop_logic" )
sampleManager:addSample("Touch", "Move-to-Touch", "ssk_sampler.touch.moveToTouch_logic" )
sampleManager:addSample("Touch", "Move-to-Touch @ Fixed Rate", "ssk_sampler.touch.moveToTouchFixedRate_logic" )
sampleManager:addSample("Touch", "Face Touch", "ssk_sampler.touch.faceTouch_logic" )
sampleManager:addSample("Touch", "Face Touch @ Fixed Rate", "ssk_sampler.touch.faceTouchFixedRate_logic" ) 

--Aiming
sampleManager:addSample("Aiming", "Aim At Object #1", "ssk_sampler.aiming.aimAtObject_logic" ) 
sampleManager:addSample("Aiming", "Aim At Object #2 (Distance Limit)", "ssk_sampler.aiming.aimAtObject2_logic" )

--Platforming
sampleManager:addSample("Platforming", "One-Way Platform", "ssk_sampler.platforming.1wayplatform_logic" )

-- Interface Elements
sampleManager:addSample("Interface Elements", "Sliding Drawer", "ssk_sampler.interface_elements.sliding_drawer_logic" )
sampleManager:addSample("Interface Elements", "Numeric Meter", "ssk_sampler.interface_elements.numericmeter_logic" )


--Games - not updated
--sampleManager:addSample("Games", "Ni", "ssk_sampler.games.ni" )
sampleManager:addSample("Games", "4-in-a-row", "ssk_sampler.games.4inarow" )


-- Game Prototypes/Experiments - not updated
--sampleManager:addSample("Prototypes", "Something Green", "ssk_sampler.prototypes.something_green" )

-- SSK and Sampler Validation
-- Labels
sampleManager:addSample("Validation", "Label Testing", "ssk_sampler._testing.labels.labels_logic" )

-- Buttons & Sliders
sampleManager:addSample("Validation", "Push Button Testing", "ssk_sampler._testing.buttons.pushButtonsTest_logic" )
sampleManager:addSample("Validation", "Toggle Button Testing", "ssk_sampler._testing.buttons.toggleButtonsTest_logic" )
sampleManager:addSample("Validation", "Radio Button Testing", "ssk_sampler._testing.buttons.radioButtonsTest_logic" )
sampleManager:addSample("Validation", "Sliders Testing", "ssk_sampler._testing.buttons.slidersTest_logic" )
sampleManager:addSample("Validation", "Standard Button Callbacks Testing", "ssk_sampler._testing.buttons.buttonCallbacksTest_logic" )

-- Templates
sampleManager:addSample("Validation", "Sampler Template 1 Test", "ssk_sampler._testing.templates.template1_logic" )
sampleManager:addSample("Validation", "Sampler Template 2 Test", "ssk_sampler._testing.templates.template2_logic" )

-- Benchmarks
sampleManager:addSample("Benchmarks", "Template", "ssk_sampler.benchmarks.template" )




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
-- 5. LOAD NECESSARY BEHAVIORS										--
----------------------------------------------------------------------
local behaviorsList = 
{

	"mover_faceTouch",
	"mover_faceTouchFixedRate",
	"mover_moveToTouchFixedRate",
	"mover_moveToTouch",
	"mover_dragDrop",
--	"mover_onTouch_applyForwardForce",
--	"mover_onTouch_applyContinuousForce",
--	"mover_onTouch_applyTimedForce",
	
	"onCollisionEnded_ExecuteCallback",
	"onCollision_ExecuteCallback",

--	"onCollisionEnded_PrintMessage",
--	"onCollision_PrintMessage",
--	"onPostCollision_PrintMessage",
--	"onPreCollision_PrintMessage",
	
--	"physics_hasForce",

}

for k,v in ipairs( behaviorsList ) do
	require( "ssk.behaviors.b_" .. v )
end

----------------------------------------------------------------------
-- 6. CALCULATE COLLISION MATRIX									--
----------------------------------------------------------------------
--[[
	Done in individual examples.  Normally (for single simple game) would be done in main however.
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
storyboard.gotoScene( "s_MainMenu" )
--storyboard.gotoScene( "s_PlayGui" )
--storyboard.gotoScene( "ssk_sampler.interface_elements.numericmeter_scene")