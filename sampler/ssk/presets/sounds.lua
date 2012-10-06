-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Sound Presets
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
-- soundsInit.lua - Initialize Game Sounds
--
local mgr = require( "ssk.classes.c_sounds" ) -- Sounds Manager
--[[
mgr:addEffect("drop", soundsDir .. "Block Drop.wav", false, true)
mgr:addEffect("click", soundsDir .. "Letter Click3.wav")
mgr:addEffect("sneeze", soundsDir .. "Sneeze-Baby.mp3")
mgr:addMusic("Music1", soundsDir .. "DeliberateThought.mp3", nil, 1500)

--]]