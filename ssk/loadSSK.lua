-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- SSK Loader 
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

-- ================================================================================
-- Load this module in main.cs to load all of the SSK library with just one call.
-- ================================================================================

-- The SSK super object; Most libraries will be attached to this.
local ssk = {}
_G.ssk = ssk 

-- =============================================================
--	ROAMING GAMER CONTENTS (Produced or Modified by Ed M.)
-- =============================================================
-- ==
--    Early Loads: This stuff is used by subsequently loaded content
-- ==
ssk.debugprinter	= require("ssk.classes.c_debugPrint")				-- Level based debug printer
ssk.advanced		= require( "ssk.classes.c_advanced" )				-- Advanced stuff (dig at your own peril; comments and criticisms welcomed)

-- ==
--    Addons - add extra functionality to existing classes, module, and global space.
-- ==
require( "ssk.addons.a_global")
require( "ssk.addons.a_io")
require( "ssk.addons.a_math")
require( "ssk.addons.a_string")
require( "ssk.addons.a_table")


--EFM split below into game object factories and other?
-- ==
--    Factories - 'Classes' that produce one or more object types.
-- ==
ssk.buttons		= require( "ssk.factories.f_buttons" )					-- Buttons & Sliders Factory
ssk.labels		= require( "ssk.factories.f_labels" )					-- Labels Factory
ssk.points		= require( "ssk.factories.f_points" )					-- Simple Points Factory (table of points)
ssk.proto		= require( "ssk.factories.f_prototyping" )  			-- Prototyping Game Objects Factory
ssk.inputs		= require( "ssk.factories.f_inputs" )					-- Joysticks and Self-Centering Sliders Factory
ssk.huds		= require( "ssk.factories.f_huds" )						-- HUDs Factory
ssk.dbmgr		= require( "ssk.factories.f_dbmgr" )					-- (Rudimentary) DB Manager Factory
ssk.spritemgr	= require( "ssk.factories.f_sprites" )					-- (Easy) Sprite Factory

-- ==
--    Classes
-- ==
ssk.behaviors	= require( "ssk.classes.c_behaviors" )					-- Behaviors Manager
ssk.bench		= require( "ssk.classes.c_benchmarking" )				-- Benchmarking Utilities
ssk.ccmgr		= require( "ssk.classes.c_collisionCalculator" )		-- Collision Calculator (EFM actually a factory now)
ssk.component	= require( "ssk.classes.c_components" )					-- Misc Game Components (Mechanics, etc.)
ssk.gem			= require( "ssk.classes.c_gem")							-- Game Event Manager
ssk.m2d			= require( "ssk.classes.c_math2d" )						-- 2D Math (scalars as inputs)
ssk.m2do		= require( "ssk.classes.c_math2do" )					-- 2D Math (objects as inputs)
ssk.misc		= require( "ssk.classes.c_miscellaneous" )				-- Miscellaneous Utilities
ssk.sbc			= require( "ssk.classes.c_standardButtonCallbacks" )	-- Standard Button & Slider Callbacks
ssk.sounds		= require( "ssk.classes.c_sounds" )						-- Sounds Manager


-- ==
--    Utilities
-- ==
-- Easy Networking (Uses mydevelopersgames free AutoLan to do heavy lifting, but written by Ed M.)
ssk.networking	= require( "ssk.utilities.u_networking" )  
ssk.networking:registerCallbacks()

-- =============================================================
--	EXTERNALLY PRODUCED (and accredited) CONTENT
-- =============================================================
ssk.pnglib		= require( "ssk.external.pngLib.pngLib" )				-- Utility lib for extracting PNG image metrics

-- =============================================================
--	PAID CONTENT - Sorry, not included. 8(
-- I have left stubs here for stuff I think you should buy.
-- This is stuff that I believe will help you develop games better and/or faster.
-- =============================================================
-- ==
--    M.Y. Developers - Profiler (Paid; http://www.mydevelopersgames.com/site/)
-- ==
--profiler = require "paid.Profiler"
--profiler.startProfiler({time = 30000, delay = 1000, mode = 4})

