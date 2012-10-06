-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Game Event Manager (uses Runtime Events and makes managing them simple)
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

local gameEventManger = {}

gameEventManger.eventsDB = {}
gameEventManger.eventGroupsDB = {}

function gameEventManger:add( eventName, handler, group )
	if(group) then
		if(not self.eventGroupsDB[group] ) then
			self.eventGroupsDB[group] = {}
		end

		local eventGroup = self.eventGroupsDB[group]
		eventGroup[handler] = eventName
	else
		self.eventsDB[handler] = eventName
	end
	Runtime:addEventListener( eventName, handler )
end

function gameEventManger:remove( eventName, handler )
	Runtime:removeEventListener( eventName, handler )
	self.eventsDB[handler] = nil
end

function gameEventManger:removeGroup( group )

	if(not self.eventGroupsDB[group] ) then
		return
	end

	local eventGroup = self.eventGroupsDB[group]

	for k,v in pairs(eventGroup) do
		Runtime:removeEventListener( v, k )
	end

	self.eventGroupsDB[group] = {}
end


function gameEventManger:removeAll( ) -- Does not affect grouped events (yet)
	for k,v in pairs(self.eventsDB) do
		Runtime:removeEventListener( v, k )
	end
	self.eventsDB = {}
end

function gameEventManger:post( eventName, eparams )
	local params = eparams or {}
	params.name = eventName
	--table.insert(params, "name", eventName)
	if( debugLevel > 1 ) then
		dprint(2,"gem:post() =>")
		for k,v in pairs(params) do 
			local ktype = type(k)
			local vtype = type(v)
			if( not (ktype == "number" or ktype == "string" or ktype == "boolean") ) then
				k = "other" 
			end
			if( not (vtype == "number" or vtype == "string" or vtype == "boolean") ) then
				v = "other" 
			end
			dprint(2, "   arg: " .. k .. " = " .. v)		
		end
		dprint(2,"----")
	end

	Runtime:dispatchEvent(params)
end

return gameEventManger