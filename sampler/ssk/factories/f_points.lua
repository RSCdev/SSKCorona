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
--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local pointsFactory = {}
	function pointsFactory:new()
		local pointsInstance = {}

		function pointsInstance:add(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
				i = i + 2
			end			
		end

		function pointsInstance:insert(index, ...)

			local index = index or 1
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				table.insert( self, index, {x=arg[i],y=arg[i+1]} )
				i = i + 2
				index = index + 1
			end			
		end

		function pointsInstance:get(index)
			local index = index or 1
			return pointsInstance[index]
		end

		function pointsInstance:remove(index)
			local index = index or 1
			local element = table.remove( self, index )
			return element
		end

		-- Treat like a stack/queue (more efficient [overall] than add(), insert(), get(), remove() above)
		function pointsInstance:push(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				pointsInstance[#pointsInstance+1] = {x=arg[i],y=arg[i+1]}
				i = i + 2
			end
		end
		function pointsInstance:peek()
			return self[#self]
		end
		function pointsInstance:pop(x,y)
			if( not #self ) then return nil end
			local element = self[#self]
			self[#self] = nil
			return element
		end
		-- add head variants (above are always tail of queue) (same efficiency as add(), insert(), get(), remove() above)
		function pointsInstance:push_head(...)
			if(#arg % 2 == 1) then return end
			local i = 1
			while(i < #arg) do
				table.insert( self, 1, {x=arg[i],y=arg[i+1]} )
				i = i + 2
			end			
		end
		function pointsInstance:peek_head()
			return self[1]
		end
		function pointsInstance:pop_head(x,y)
			local element = table.remove( self, 1 )
			return element
		end

		return pointsInstance
	end

return pointsFactory