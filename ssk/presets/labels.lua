-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Labels Presets
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

--
-- labelsInit.lua - Create Label Presets
--
local mgr			= require( "ssk.factories.f_labels" )

-- ============================
-- =============== DEFAULT
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 255,255,255, 255 },
}
mgr:addPreset( "default", params )

-- ============================
-- ============== RIGHT LABEL
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 255,255,255, 255 },
	referencePoint = display.CenterRightReferencePoint,
}
mgr:addPreset( "rightLabel", params )

-- ============================
-- ============== LEFT LABEL
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 255,255,255, 255 },
	referencePoint = display.CenterLeftReferencePoint,
}
mgr:addPreset( "leftLabel", params )


-- ============================
-- =============== BLACK
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 0,0,0, 255 },
}
mgr:addPreset( "black", params )


-- ============================
-- =============== WHITE
-- ============================
local params = 
{ 
	font      = native.systemFont,
	fontSize  = 12,
	textColor     = { 2552,255,255, 255 },
}
mgr:addPreset( "white", params )

-- ============================
-- =============== PAGE HEADERS
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 38,
	emboss         = true,
	--embossTextColor     = { 200,32,32, 200 },
	embossTextColor     = { 32,32,200, 200 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
}
mgr:addPreset( "headerLabel", params )

-- ============================
-- ============== General LABEL
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 16,
	emboss         = false,
	textColor          = { 0,0,0, 255 },
	embossTextColor     = { 0,0,0, 255 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
	referencePoint = display.CenterRightReferencePoint,
}
mgr:addPreset( "generalLabel", params )


-- ============================
-- ============== Centered LABEL
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 16,
	emboss         = false,
	textColor          = { 0,0,0, 255 },
	embossTextColor     = { 0,0,0, 255 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
	referencePoint = display.CenterReferencePoint,
}
mgr:addPreset( "centeredLabel", params )


-- ============================
-- ======= Player Welcome LABEL
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 18,
	emboss         = false,
	textColor          = { 0,0,0, 255 },
	embossTextColor     = { 0,0,0, 255 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
	referencePoint = display.CenterRightReferencePoint,
}
mgr:addPreset( "playerWelcome", params )

-- ============================
-- ========== Player Name LABEL
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 33,
	emboss         = false,
	textColor          = { 0,0,0, 255 },
	embossTextColor     = { 0,0,0, 255 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
	referencePoint = display.CenterRightReferencePoint,
}
mgr:addPreset( "playerLabel", params )




-- ============================
-- ============== OPTIONS LABEL
-- ============================
local params = 
{ 
	font           = gameFont,
	fontSize       = 22,
	emboss         = false,
	textColor          = { 0,0,0, 255 },
	embossTextColor     = { 0,0,0, 255 },
	embossHighlightColor = { 255,255,255, 255 },
	embossShadowColor    = { 0,0,0, 255 },
	referencePoint = display.CenterRightReferencePoint,
}
mgr:addPreset( "optionLabel", params )


