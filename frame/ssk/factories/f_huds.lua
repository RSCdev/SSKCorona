-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- HUDS Factory
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


--[[ 
-- EFM make this library use trash and chained removeSelf func too

function public:createTimeHUD( x, y, presetName, group, params)
- function theHUD:get()
- function theHUD:set( seconds )
- function theHUD:autoCount( maxTime, callback)
- function theHUD:autoCountDown( minTime, callback )
- function theHUD:destroy()

function public:createNumericScoreHUD( x, y, digits, presetName, group, params)
- function theHUD:get()
- function theHUD:set( value )
- function theHUD:destroy()

--]]


public = {}

public.instances = {}

function public:cleanup()
end

-- =================================================
--  Time HUD (w/ countdown, countup features)
-- =================================================
function public:createTimeHUD( x, y, presetName, group, params)
	local theHUD = ssk.labels:presetLabel( group, presetName, "0:00", x, y, params  )

	group:insert(theHUD)

	theHUD.curTime = 0
	theHUD.x, theHUD.y = x,y
	theHUD.myx, theHUD.myy = x,y

	theHUD.firstPass = true

	function theHUD:get()
		return self.curTime
	end

	function theHUD:set( seconds )
		self.curTime = seconds
		self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
		self.x, self.y = self.myx, self.myy
	end

	function theHUD:autoCount( maxTime, callback)
		
		self.timer = function()
			self.curTime = self.curTime + 1
			self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			if( maxTime and ( self.curTime == maxTime ) )then
				if(callback) then
					callback( self )
				end
				timer.cancel(self.myTimer)
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end

	function theHUD:autoCountDown( minTime, callback )
		
		self.timer = function()
			self.curTime = self.curTime - 1
			if(self.curTime >= 0) then
				self:setText( ssk.misc.convertSecondsToTimer( self.curTime ) )
			end

			if( minTime and ( self.curTime == minTime ) )then
				if(callback) then
					callback( self )
				end
				timer.cancel(self.myTimer)
				return
			end			
		end
		self.myTimer = timer.performWithDelay( 1000, self, 0 )
	end


	function theHUD:destroy()
	end

	return theHUD
end


-- =================================================
--  Score HUD
-- =================================================
function public:createNumericScoreHUD( x, y, digits, presetName, group, params)
	local theHUD = ssk.labels:presetLabel( group, presetName, string.lpad( "0", digits,'0'), x, y, params  )

	group:insert(theHUD)

	theHUD.curValue = 0
	theHUD.x, theHUD.y = x,y
	theHUD.myx, theHUD.myy = x,y

	theHUD.firstPass = true

	function theHUD:get()
		return self.curValue
	end

	function theHUD:set( value )
		self.curValue = value
		self:setText( string.lpad( tostring(value) , digits,'0') )
		--self.x, self.y = self.myx, self.myy
	end

	function theHUD:destroy()
	end

	return theHUD
end

return public