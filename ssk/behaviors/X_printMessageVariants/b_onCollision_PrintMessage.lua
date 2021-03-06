-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Behavior - Debug: onCollision Print Message
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


public = {}
public._behaviorName = "onCollision - Print Message"

function public:onAttach( obj, params )
	print("Attached Behavior: " .. self._behaviorName)
	behaviorInstance = {}
	behaviorInstance._behaviorName = self._behaviorName

	if( not params ) then params = {} end
	behaviorInstance.params = params

	function behaviorInstance:collision( event )
		local target = event.target
		local other  = event.other

		if( event.phase == "began" ) then
			if(not target.myName ) then target.myName = "An Object" end
			if(not other.myName ) then other.myName = "Another Object" end
			print(target.myName .. " collided with " .. other.myName .. " @ time: " .. system.getTimer())			
		end

		return false
	end

	obj:addEventListener( "collision", behaviorInstance )

	return behaviorInstance
end

ssk.behaviors:registerBehavior( "onCollision_PrintMessage", public )
return public
