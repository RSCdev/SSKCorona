-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Buttons Presets
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
local mgr			= require( "ssk.factories.f_buttons" )    -- Buttons, Sliders

-- ============================
-- ========= DEFAULT BUTTON
-- ============================
local default_params = 
{ 
	textColor          = { 0, 0, 0, 255 },
	fontSize           = 16,
	textFont           = native.systemFontBold,
	unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 64, 64, 64, 255 }, "down" ),
	selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 94, 94, 94, 255 }, "down" ),
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
	textOffset         = {0,1},
	emboss             = false,
}
mgr:addPreset( "default", default_params )

-- ============================
-- ========= OPAQUE BLUE 
-- ============================
local params = 
{ 
	textColor			= { 0, 0, 0, 255 },
	fontSize			= 21,
	textFont			= gameFont,
	unselRectFillColor	= {0,0,255,255},
	selRectFillColor	= {0,0,200,255},
	unselRectEn			= true,
	selRectEn			= true,
	strokeWidth			= 2,
    strokeColor			= {1,1,1,128},
	textOffset			= {0,1},
	emboss				= true,
}
mgr:addPreset( "blue", params )

-- ============================
-- ========= OPAQUE RED 
-- ============================
params.unselRectFillColor	= {255,0,0,255}
params.selRectFillColor		= {200,0,0,255}

mgr:addPreset( "red", params )

-- ============================
-- ================ BLUE GRADIENT
-- ============================
local params = 
{ 
	textColor          = { 0, 0, 0, 255 },
	fontSize           = 18,
	textFont           = gameFont,
	unselRectGradient  = graphics.newGradient ( { 170, 170, 255, 255  }, { 64, 64, 255, 255 }, "down" ),
	selRectGradient    = graphics.newGradient ( { 200, 200, 220, 255  }, { 94, 94, 220, 255 }, "down" ),
	strokeWidth        = 1,
    strokeColor        = {1,1,1,128},
	textOffset         = {0,1},
	emboss             = true,
}

mgr:addPreset( "blueGradient", params )

-- ============================
-- =============== GREEN GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 200, 220, 200, 255  }, { 32, 220,32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 220, 255, 220, 255  }, { 0, 255, 0, 255 }, "down" )
mgr:addPreset( "greenGradient", params )

-- ============================
-- ========== BLUE/GREEN GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 255, 255  }, { 64, 64, 255, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 220, 255, 220, 255  }, { 0, 255, 0, 255 }, "down" )
mgr:addPreset( "blueGreenGradient", params )

-- ============================
-- ================= RED GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 255, 128 , 128, 255  }, { 255, 32, 32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 64, 64, 255  }, { 255, 32, 32, 255 }, "down" )

params.unselRectGradient  = graphics.newGradient ( { 255, 128, 128, 255  }, { 220, 32, 32, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 170, 170, 255  }, { 255, 0, 0, 255 }, "down" )

mgr:addPreset( "redGradient", params )

-- ============================
-- ============== ORANGE GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 64, 64, 64, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 94, 94, 94, 255 }, "down" )
params.buttonOverlayRectColor = {0xff, 0x99, 0x00, 180}
mgr:addPreset( "orangeGradient", params )

-- ============================
-- ============== YELLOW GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 170, 170, 170, 255  }, { 94, 94, 94, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 200, 200, 200, 255  }, { 128, 128, 128, 255 }, "down" )
params.buttonOverlayRectColor = { 0xff, 0xff, 0x00, 200}
mgr:addPreset( "yellowGradient", params )

-- ============================
--================ WHITE GRADIENT
-- ============================
params.unselRectGradient  = graphics.newGradient ( { 230, 230, 230, 255  }, { 160, 160, 160, 255 }, "down" )
params.selRectGradient    = graphics.newGradient ( { 255, 255, 255, 255  }, { 180, 180, 180, 255 }, "down" )
params.buttonOverlayRectColor = nil
mgr:addPreset( "whiteGradient", params )


-- ============================
-- ================== RG BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "badges/rg.png"
params.selImgSrc   = imagesDir .. "badges/rg.png"
params.unselRectEn = true
params.selRectEn   = true
params.strokeWidth = 0
mgr:addPreset( "RGButton", params )

-- ============================
-- ======= Corona  BADGE/BUTTON 150 x 144
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "badges/coronaBadge_smallt.png"
params.selImgSrc   = imagesDir .. "badges/coronaBadge_smallt.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "CoronaButton", params )


-- ============================
-- ======= Corona  BADGE/BUTTON 75 x 72
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "badges/coronaBadge_tinyt.png"
params.selImgSrc   = imagesDir .. "badges/coronaBadge_tinyt.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "CoronaButtonTiny", params )

-- ============================
-- ================ HOME BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "interface/home.png"
params.selImgSrc   = imagesDir .. "interface/homeOver.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "homeButton", params )


-- ============================
-- ================ UP BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.unselImgSrc = imagesDir .. "interface/buttonUp.png"
params.selImgSrc   = imagesDir .. "interface/buttonUpOver.png"
params.unselRectEn = false
params.selRectEn   = false
params.strokeWidth = 0
mgr:addPreset( "upButton", params )
-- ============================
-- ================ DOWN BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonDown.png"
params.selImgSrc   = imagesDir .. "interface/buttonDownOver.png"
mgr:addPreset( "downButton", params )
-- ============================
-- ================ RIGHT BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonRight.png"
params.selImgSrc   = imagesDir .. "interface/buttonRightOver.png"
mgr:addPreset( "rightButton", params )
-- ============================
-- ================ LEFT BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonLeft.png"
params.selImgSrc   = imagesDir .. "interface/buttonLeftOver.png"
mgr:addPreset( "leftButton", params )
-- ============================
-- ================ 'A' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonA.png"
params.selImgSrc   = imagesDir .. "interface/buttonAOver.png"
mgr:addPreset( "A_Button", params )
-- ============================
-- ================ 'B' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonB.png"
params.selImgSrc   = imagesDir .. "interface/buttonBOver.png"
mgr:addPreset( "B_Button", params )
-- ============================
-- ================ 'C' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonC.png"
params.selImgSrc   = imagesDir .. "interface/buttonCOver.png"
mgr:addPreset( "C_Button", params )
-- ============================
-- ================ 'D' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonD.png"
params.selImgSrc   = imagesDir .. "interface/buttonDOver.png"
mgr:addPreset( "D_Button", params )
-- ============================
-- ================ 'E' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonE.png"
params.selImgSrc   = imagesDir .. "interface/buttonEOver.png"
mgr:addPreset( "E_Button", params )
-- ============================
-- ================ 'F' BUTTON
-- ============================
params.unselImgSrc = imagesDir .. "interface/buttonF.png"
params.selImgSrc   = imagesDir .. "interface/buttonFOver.png"
mgr:addPreset( "F_Button", params )

-- ============================
-- ================== MP BUTTON
-- ============================
local params = 
{ 
	textColor			= { 0, 0, 0, 255 },
	unselRectEn			= true,
	selRectEn			= true,

	unselRectFillColor	= {255,255,255,255},
	selRectFillColor	= {255,255,255,255},
	
	unselImgSrc			= imagesDir .. "interface/spOverlay.png",
	selImgSrc			= imagesDir .. "interface/mpOverlay.png",

	strokeWidth			= 2,
    strokeColor			= {0,0,0,128},
}
mgr:addPreset( "mpButton", params )

-- ============================
-- ============= OPTIONS BUTTON
-- ============================
params.buttonOverlayRectColor = nil
params.selRectFillColor	= {200,200,200,255}
params.unselImgSrc = imagesDir .. "interface/gear.png"
params.selImgSrc   = imagesDir .. "interface/gear.png"
params.unselRectEn = true
params.selRectEn   = true
mgr:addPreset( "optionsButton", params )

