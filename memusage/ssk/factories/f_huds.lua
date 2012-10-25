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

	function theHUD:stop()
		if( self.myTimer ) then
			timer.cancel(self.myTimer)
			self.myTimer = nil
		end
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

	theHUD.digits = digits or 0

	function theHUD:get()
		return self.curValue
	end

	function theHUD:set( value )
		self.curValue = value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	function theHUD:increment( value )
		self.curValue = self.curValue + value
		if(self.digits) then
			self:setText( string.lpad( tostring(self.curValue) , self.digits,'0') )
		else
			self:setText( tostring(value) )
		end
	end

	function theHUD:destroy()
	end

	return theHUD
end

-- =================================================
--  Horizonal Image Counter 
-- =================================================
function public:createHorizImageCounter( group, x, y, imgSrc, imgW, imgH, maxValue, intialValue )
	
	local initialValue = initialValue or 0

	local theHUD = display.newGroup()
	group:insert(theHUD)

	theHUD.myx, theHUD.myy = x,y
	theHUD.curValue = 0
	theHUD.maxValue = maxValue

	for i=1, maxValue do
		local img = display.newImageRect( theHUD, imgSrc, imgW, imgH )
		img.x = (i-1) * imgW
		img.y = 0
	end

	theHUD:setReferencePoint(display.CenterReferencePoint)
	theHUD.x, theHUD.y = x,y


	function theHUD:set( value )
		self.curValue = value
		if(self.curValue < 0) then self.curValue = 0 end
		if(self.curValue > self.maxValue) then self.curValue = self.maxValue end

		for i=1, self.maxValue do
			if(i > self.curValue) then
				self[i].isVisible = false
			else
				self[i].isVisible = true
			end
		end

		print(self.width, self.height,self.x, self.y, self.myx)
	end

	theHUD:set( intialValue )

	function theHUD:get()
		return self.curValue
	end
	function theHUD:increment( value )
		self.curValue = self.curValue + value
		self:set( self.curValue )
	end

	function theHUD:destroy()
	end

	return theHUD
end

return public