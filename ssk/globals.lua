-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- SSK Globals
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


-- You may (and probably should) modify the following globals to suit the needs of your game
-- You may (and probably should) modify the following globals to suit the needs of your game
-- You may (and probably should) modify the following globals to suit the needs of your game

-- Debug messaging level (used by debugPrint): 
-- 0  - None
-- 1  - Basic messages
-- 2  - Intermediate debug output
-- 3+ - Full debug output (may be very noisy)
_G.debugLevel = 1

-- Version details and flags
_G.isTutorialDistro = true -- I can't distribute some 'paid' assets with the kit, so this
                         -- flag is used to select alternative assets for the source distro version.
_G.liteVersion = false
_G.releaseDate  = "18 OCT 2012"

-- Resource directories (images, sounds, etc.)
_G.imagesDir = "images/"
_G.soundsDir = "sounds/"

-- Outline colors (if used)
_G.topLineColor      = {0,0,0,180}
_G.botLineColor      = {255,255,255,200}

-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY
-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY
-- DO NOT MODIFY BELOW (Used In Framework); EXPERTS ONLY

_G.SPC = ' '
_G.NL  = '\n'
_G.TAB = '\t'

_G.w = display.contentWidth
_G.h = display.contentHeight

_G.centerX = w/2
_G.centerY = h/2

_G.scaleX = 1/display.contentScaleX
_G.scaleY = 1/display.contentScaleY

_G.displayWidth        = (display.contentWidth - display.screenOriginX*2)
_G.displayHeight       = (display.contentHeight - display.screenOriginY*2)

_G.unusedWidth    = _G.displayWidth - _G.w
_G.unusedHeight   = _G.displayHeight - _G.h

_G.deviceWidth  = math.floor((displayWidth/display.contentScaleX) + 0.5)
_G.deviceHeight = math.floor((displayHeight/display.contentScaleY) + 0.5)

_G.onSimulator = system.getInfo( "environment" ) == "simulator"
_G.platformVersion = system.getInfo( "platformVersion" )
_G.olderVersion = tonumber(string.sub( platformVersion, 1, 1 )) < 4

-- easy color codes and string translations
_G.colorNames = {}
_G._TRANSPARENT_ = {0, 0, 0, 0}; _G.colorNames[_TRANSPARENT_] = "TRANSPARENT"

_G._WHITE_ = {255, 255, 255, 255}; _G.colorNames[_WHITE_] = "WHITE"
_G._BLACK_ = {  0,   0,   0, 255}; _G.colorNames[_BLACK_] = "BLACK"

_G._GREY_      = {128, 128, 128, 255}; _G.colorNames[_GREY_] = "GREY"
_G._DARKGREY_  = { 64,  64,  64, 255}; _G.colorNames[_DARKGREY_] = "DARKGREY"
_G._LIGHTGREY_ = {192, 192, 192, 255}; _G.colorNames[_LIGHTGREY_] = "LIGHTGREY"

_G._RED_   = {255,   0,   0, 255}; _G.colorNames[_RED_] = "RED"
_G._GREEN_ = {  0, 255,   0, 255}; _G.colorNames[_GREEN_] = "GREEN"
_G._BLUE_  = {  0,   0, 255, 255}; _G.colorNames[_BLUE_] = "BLUE"

_G._YELLOW_       = {0xff, 0xff,    0, 255}; _G.colorNames[_YELLOW_] = "YELLOW"
_G._ORANGE_       = {0xff, 0x66,    0, 255}; _G.colorNames[_ORANGE_] = "ORANGE"
_G._BRIGHTORANGE_ = {0xff, 0x99,    0, 255}; _G.colorNames[_BRIGHTORANGE_] = "BRIGHTORANGE"
_G._PURPLE_       = {0xa0, 0x20, 0xf0, 255}; _G.colorNames[_PURPLE_] = "PURPLE"
_G._PINK_         = {0xff, 0x6e, 0xc7, 255}; _G.colorNames[_PINK_] = "PINK"

