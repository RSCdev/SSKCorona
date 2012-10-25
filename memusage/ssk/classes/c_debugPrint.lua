-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Debug Printer
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

--[[  USAGE:
local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = debugPrinter.newPrinter( debugLevel )
local dprint = dp.print

dprint( 2, "Some message", "that should", "only print at level 2 or higher")
--]]

local dp = {}

	function dp.newPrinter( debugLevel )

		if(debugLevel == nil) then
			print("Warning: Passed nil when initializing debugLevel in dp.newPrinter()")
		end

		local thePrinter = {}

		-- Debug messaging level: 
		-- 0  - None
		-- 1  - Basic messages
		-- 2  - Intermediate debug output
		-- 3+ - Full debug output (may be very noisy)
		thePrinter.debugLevel = debugLevel or 0

		function thePrinter:setLevel( level )
			self.debugLevel = level			
		end

		function thePrinter.print( level, ... )
			if(thePrinter.debugLevel >= level ) then
				print( unpack(arg) )
			end
		end

		return thePrinter
	end

return dp
