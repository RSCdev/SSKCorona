-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Behavior - onCollision Began Execute Callback
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

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

public = {}
public._behaviorName = "onCollision_ExecuteCallback"

function public:onAttach( obj, params )
	dprint(1,"Attached Behavior: " .. self._behaviorName)

	if(not params.callback) then
		error("Error: onCollision_ExecuteCallback behavior => no callback supplied!")
		return nil
	end

	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	behaviorInstance.params = table.shallowCopy(params)

	function behaviorInstance:collision( event )
		local target = event.target
		local other  = event.other
		--Note: use 'self' to reference the behavior instance
		
		if( event.phase == "began" ) then
			local theCallback = self.params.callback
			if(theCallback) then
				theCallback( event )
			else
				dprint(1,"Behavior: onCollision_ExecuteCallback - No callback supplied?" )
			end	
		end
		return false
	end

	obj:addEventListener( "collision", behaviorInstance )

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "onCollision_ExecuteCallback", public )

return public
