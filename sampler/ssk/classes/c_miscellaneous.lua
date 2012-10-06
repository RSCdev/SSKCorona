-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Miscellaneous Utilities
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

local misc = {}

function misc.convertSecondsToTimer( seconds )
	local seconds = tonumber(seconds)
	local minutes = math.floor(seconds/60)
	local remainingSeconds = seconds - (minutes * 60)

	local timerVal = "" 

	if(remainingSeconds < 10) then
		timerVal =  minutes .. ":" .. "0" .. remainingSeconds
	else
		timerVal = minutes .. ":"  .. remainingSeconds
	end

	return timerVal
end

function misc.dumpScreenMetrics()

	print("\nApplication designed to these specs:\n")
	print("         design width (w) = " .. w)
	print("        design height (h) = " .. h)
	print("design center X (centerX) = " .. centerX)
	print("design center Y (centerY) = " .. centerY)
	
	print("\nPhysical (Unscaled) Screen Specs:\n")
	print("              deviceWidth = " .. deviceWidth)
	print("             deviceHeight = " .. deviceHeight .. NL)

	print("\nScaling (warning content scaled to retain original w vs h ratio):\n")
	print("  content scale X (scaleX) = " .. round(scaleX,3))
	print("  content scale Y (scaleY) = " .. round(scaleY,3) .. NL)

	print("\nVisible scaled screen (may be wider and/or taller than design specs):\n")
	print("              displayWidth = " .. displayWidth)
	print("             displayHeight = " .. displayHeight .. NL)

	print("\Unused scaled pixels:\n")
	print("               unusedWidth = " .. unusedWidth)
	print("               unusedHeight = " .. unusedHeight)

end

function misc.processEvent( obj, event, doDeltas, doTouchVec, doTouchAngle )

	local doDeltas     = doDeltas or false
	local doTouchAngle = doTouchAngle or false
	local doTouchVec   = doTouchVec or doTouchAngle or false

	if(event.phase == "began") then	
		obj.isActive = true

		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.startTime          = event.time
		obj.activeTime         = 0
		obj.lastInputTime      = event.time
		obj.inputTime          = event.time
		obj.deltaTime          = 0

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = 0,0
			obj.deltaLen          = 0
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = 0,0
			obj.touchVecLen             = 0
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			obj.touchAngle = 0
		end		

	elseif(event.phase == "moved" or event.phase == "ended" or event.phase == "cancelled") then	
		obj.startX, obj.startY = event.xStart, event.yStart
		obj.lastX, obj.lastY   = obj.curX, obj.curY
		obj.curX, obj.curY     = event.x, event.y

		obj.activeTime         = event.time - obj.startTime
		obj.lastInputTime      = obj.inputTime
		obj.inputTime          = event.time
		obj.deltaTime          = obj.inputTime - obj.lastInputTime

		-- Calculate deltas between last input and current input
		if(doDeltas) then
			obj.deltaX,obj.deltaY = ssk.m2d.sub(obj.lastX, obj.lastY, obj.curX, obj.curY )
			obj.deltaLen          = ssk.m2d.length(obj.deltaX,obj.deltaY)
		end

		-- Calculate touch vector:  startXY ------> curXY
		if(doTouchVec) then
			obj.touchVecX,obj.touchVecY = ssk.m2d.sub(obj.startX, obj.startY, obj.curX, obj.curY )
			obj.touchVecLen             = ssk.m2d.length(obj.touchVecX,obj.touchVecY)
		end

		-- Calculate angle of touch vector:  startXY ------> curXY
		if(doTouchAngle) then
			local nx,ny    = ssk.m2d.normalize(obj.touchVecX,obj.touchVecY) -- EFM necessary?
			obj.touchAngle = ssk.m2d.vector2Angle(nx,ny)
		end
	end
end

return misc
