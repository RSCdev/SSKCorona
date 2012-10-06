-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Behaviors Manager
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

behaviorsManager = {}

behaviorsManager.knownBehaviors = {}

function behaviorsManager:registerBehavior( behaviorName, behaviorObject )	
	dprint(1,"behaviorsManager:registerBehavior( \"" .. behaviorName .. "\" , " .. tostring(behaviorObject) .. " )" )	
	if(self.knownBehaviors[behaviorName] ~= nil) then
		-- EFM - Not really an error
		-- EFM - Allow multiple requires of same behavior (users can access them locally)
		dprint(2,"WARNING: Attempting to register behavior using previously used behavior name: ", behaviorName )
		return
	end

	self.knownBehaviors[behaviorName] = behaviorObject
end

function behaviorsManager:attachBehavior( obj, behaviorName, params )
	dprint(2,"behaviorsManager:attachBehavior(",obj, behaviorName , ")" )	

	local behaviorObject = self.knownBehaviors[behaviorName]
	if(not behaviorObject) then
		print("ERROR: Attempting to attach behavior using unknown behavior name: ", behaviorName )
		return false
	end

	local theBehavior = behaviorObject:onAttach( obj, params )

	if(not theBehavior) then
		return false
	end

	-- Track behavior owner
	theBehavior.owner = obj

	-- keep track of attached behaviors (per object)
	if(not obj._behaviorsAttached) then
		obj._behaviorsAttached = {}
	end
	obj._behaviorsAttached[theBehavior] = theBehavior


	-- Add a custom removeSelf() function to obj that removes any attached behaviors from the object 
	-- when obj:removeSelf() is called
	local function custom_removeSelf( self ) 
		dprint(2,"behaviorsManager:custom_removeSelf()")	
		ssk.behaviors:detachBehaviors(self)
	end

	ssk.advanced.addCustom_removeSelf( obj, custom_removeSelf )

	return true
end

function behaviorsManager:attachBehaviors( obj, behaviorsTable )
	dprint(2,"behaviorsManager:attachBehaviors(",obj, behaviorsTable , ")" )	

	local retval = true
	for i=1, #behaviorsTable do
		local curBehavior = behaviorsTable[i]
		dprint(3,"behaviorsTable[" .. i .. "] == " .. curBehavior[1] )
		retval = retval and self:attachBehavior(obj, curBehavior[1], curBehavior[2])
	end
	return retval
end

function behaviorsManager:detachBehaviors( obj )
	dprint(2,"behaviorsManager:detachBehaviors(",obj , ")" )	
	if( not obj._behaviorsAttached ) then
		return false
	end

	for k,v in pairs(obj._behaviorsAttached) do
		if(v.onDetach) then 
			v:onDetach( obj )
			-- Clear reference to owner object
			v.owner = nil
		end
	end

	return true
end

function behaviorsManager:hasBehaviors( obj )
	if( not obj._behaviorsAttached ) then
		return false
	end
	return true
end


return behaviorsManager
