-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Input Objects Factory
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
--EFM modify these to work seamlessly with trash and chained removeSelf functionality
function inputsFactory:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, interfaceLayer )
function inputsFactory:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, interfaceLayer )
function inputsFactory:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, interfaceLayer )
function inputsFactory:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, inputObj, interfaceLayer )
function inputsFactory:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, interfaceLayer )
function inputsFactory:createVirtualVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, inputObj, interfaceLayer )
--]]

--local debugLevel = 2 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

local inputsFactory = {}


-- =======================
-- ====================== Joystick
-- =======================
function inputsFactory:createJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, interfaceLayer )

	local joystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( interfaceLayer ) then
		interfaceLayer:insert(joystick)
	end
	

	local outerRing  = ssk.proto.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.proto.circle( joystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local stick  = ssk.proto.circle( joystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 

	local radiusDelta = outerRadius - deadZoneRadius
	
	function joystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x,stick.y = event.x, event.y
		end

		local vx,vy = ssk.m2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.m2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.m2d.vector2Angle(vx,vy)
		end

		local vLen  = ssk.m2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.m2d.angle2Vector(angle)
					dx,dy = ssk.m2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.m2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end

	outerRing:addEventListener( "touch", joystick )		

	function joystick:destroy( event )
		outerRing:removeEventListener( "touch", joystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
	end
		
	return joystick
end

-- =======================
-- ====================== Virtual Joystick
-- =======================
function inputsFactory:createVirtualJoystick( x, y, outerRadius, deadZoneRadius, stickRadius, eventName, inputObj, interfaceLayer )

	local virtualJoystick  = display.newGroup()

	local eventName = eventName or "joystickEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end
	
	if( interfaceLayer ) then
		interfaceLayer:insert(virtualJoystick)
	end

	local outerRing  = ssk.proto.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 4, 
		  radius = outerRadius, myName = "aJoystick" }, nil, nil ) 
	outerRing.alpha = 0.50
	
	local innerRing  = ssk.proto.circle( virtualJoystick, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  radius = deadZoneRadius, myName = "aJoystick" }, nil, nil ) 

	local stick  = ssk.proto.circle( virtualJoystick, x, y,
		{ fill = _GREY_, stroke = _GREY_, strokeWidth = 0, 
		  radius = stickRadius, myName = "aJoystick" }, nil, nil ) 
	innerRing.alpha = 0.50

	local radiusDelta = outerRadius - deadZoneRadius

	virtualJoystick.isVisible = false

	function virtualJoystick:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true

			local newX,newY = event.x,event.y

			if( (newX + outerRing.width/2) >= w) then
				newX = w - outerRing.width/2
			end

			if( (newX - outerRing.width/2) <= 0 ) then
				newX = outerRing.width/2
			end

			if( (newY + outerRing.height/2) >= h) then
				newY = h - outerRing.height/2
			end

			if( (newY - outerRing.height/2) <= 0) then
				newY = outerRing.height/2
			end

			outerRing.x,outerRing.y = newX, newY
			innerRing.x,innerRing.y = newX, newY
			stick.x,stick.y = event.x,event.y
			virtualJoystick.isVisible = true
		end

		local vx,vy = ssk.m2d.sub(outerRing.x, outerRing.y, event.x, event.y)
		local nx,ny = ssk.m2d.normalize(vx,vy)

		if(vx == 0 ) then
			nx = 0
		else
			nx = round(nx,4)
		end

		if(vy == 0 ) then
			ny = 0
		else
			ny = round(ny,4)	
		end

		local angle 

		if(nx == 0 and ny == 0 ) then
			angle = 0
		else
			angle = ssk.m2d.vector2Angle(vx,vy)
		end

		local vLen  = ssk.m2d.length(vx,vy)
		
		local iLen  = vLen - deadZoneRadius

		local percent = 0

		if(event.phase == "began") then
			if(iLen < 0) then
				percent = 0
			elseif(iLen > radiusDelta) then
				percent = 1
			else
				percent = iLen/radiusDelta
			end

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x,stick.y = outerRing.x, outerRing.y

				angle = 0
				vx = 0
				vy = 0
				nx = 0
				ny = 0
				percent = 0

				virtualJoystick.isVisible = false

			elseif(event.phase == "moved") then
				if(vLen <= outerRadius ) then
					stick.x,stick.y = event.x, event.y
				else
					local dx,dy = ssk.m2d.angle2Vector(angle)
					dx,dy = ssk.m2d.scale(dx,dy,outerRadius)
					stick.x,stick.y = ssk.m2d.add( outerRing.x, outerRing.y, dx,dy)
				end
				if(iLen < 0) then
					percent = 0
				elseif(iLen > radiusDelta) then
					percent = 100
				else
					percent = round(iLen/radiusDelta,4) * 100
				end
			end
		end
		
		dprint(2, round(angle,2), round(nx,2), round(ny,2), round(percent,2))
		if(percent == 0 ) then
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "off" })
		else
			ssk.gem:post(eventName, {angle=angle, vx=vx, vy=vy, nx=nx, ny=ny, percent=percent, phase = event.phase, state = "on" })
		end
		return true
	end


	inputObj:addEventListener( "touch", virtualJoystick )			

	function virtualJoystick:destroy( event )
		inputObj:removeEventListener( "touch", virtualJoystick )		
		stick:removeSelf()
		innerRing:removeSelf()
		outerRing:removeSelf()
	end
	
	return virtualJoystick
end

-- =======================
-- ====================== horizSnap
-- =======================
function inputsFactory:createHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, interfaceLayer )

	local horizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( interfaceLayer ) then
		interfaceLayer:insert(horizSnap)
	end

	local horizSnapOutline  = ssk.proto.rect( horizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.proto.rect( horizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = deadZoneWidth, height = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.proto.rect( horizSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = stickSize, height = snapHeight-2, myName = "ahorizSnap" }, nil, nil ) 
		
	function horizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.x = event.x

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x
				
				vx=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	horizSnapOutline:addEventListener( "touch", horizSnap )		


	function horizSnap:destroy( event )
		horizSnapOutline:removeEventListener( "touch", horizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
	end
		
	return horizSnap
end

-- =======================
-- ====================== virtualHorizSnap
-- =======================
function inputsFactory:createVirtualHorizontalSnap( x, y, snapHeight, snapWidth, deadZoneWidth, stickSize, eventName, inputObj, interfaceLayer )

	local virtualhorizSnap  = display.newGroup()

	local eventName = eventName or "horizSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( interfaceLayer ) then
		interfaceLayer:insert(virtualhorizSnap)
	end

	local horizSnapOutline  = ssk.proto.rect( virtualhorizSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapOutline.alpha = 0.50

	local horizSnapDeadZone  = ssk.proto.rect( virtualhorizSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = deadZoneWidth, height = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 
	horizSnapDeadZone.alpha = 0.50

	local stick  = ssk.proto.rect( virtualhorizSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = stickSize, height = snapHeight-2, myName = "avirtualhorizSnap" }, nil, nil ) 

	virtualhorizSnap.isVisible = false
		
	function virtualhorizSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + horizSnapOutline.width/2) >= w) then
				newX = w - horizSnapOutline.width/2
			end

			if( (newX - horizSnapOutline.width/2) <= 0 ) then
				newX = horizSnapOutline.width/2
			end

			if( (newY + horizSnapOutline.height/2) >= h) then
				newY = h - horizSnapOutline.height/2
			end

			if( (newY - horizSnapOutline.height/2) <= 0) then
				newY = horizSnapOutline.height/2
			end

			horizSnapOutline.x,horizSnapOutline.y = newX, newY
			horizSnapDeadZone.x,horizSnapDeadZone.y = newX, newY
			stick.x,stick.y = event.x,newY

			virtualhorizSnap.isVisible = true
		end

		local vx = event.x - horizSnapOutline.x 
		local direction = "left"

		if(vx > 0) then
			direction = "right"
		end

		local magnitude = math.abs(vx)
		local maxMag = snapWidth/2
		local minMag = deadZoneWidth/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.x = horizSnapOutline.x				
				vx=0
				percent=0
				direction = "center"

				virtualhorizSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.x = event.x
				if(percent == 100 and direction == "left" ) then
					stick.x = horizSnapOutline.x - horizSnapOutline.width/2
				elseif(percent == 100 and direction == "right" ) then
					stick.x = horizSnapOutline.x + horizSnapOutline.width/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=vx, vy=0, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualhorizSnap )		


	function virtualhorizSnap:destroy( event )
		inputObj:removeEventListener( "touch", virtualhorizSnap )		
		stick:removeSelf()
		horizSnapDeadZone:removeSelf()
		horizSnapOutline:removeSelf()
	end
		
	return virtualhorizSnap
end

-- =======================
-- ====================== vertSnap
-- =======================
function inputsFactory:createVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, interfaceLayer )

	local vertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( interfaceLayer ) then
		interfaceLayer:insert(vertSnap)
	end

	local vertSnapOutline  = ssk.proto.rect( vertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.proto.rect( vertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = snapWidth-2, height = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.proto.rect( vertSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = snapWidth, height = stickSize, myName = "avertSnap" }, nil, nil ) 

	function vertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			stick.y = event.y

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.y = vertSnapOutline.y
				
				vy=0
				percent=0
				direction = "center"


			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end
		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	vertSnapOutline:addEventListener( "touch", vertSnap )		


	function vertSnap:destroy( event )
		vertSnapOutline:removeEventListener( "touch", vertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
	end

	return vertSnap
end


-- =======================
-- ====================== virtualVertSnap
-- =======================
function inputsFactory:createVirtualVerticalSnap( x, y, snapWidth, snapHeight, deadZoneHeight, stickSize, eventName, inputObj, interfaceLayer )

	local virtualVertSnap  = display.newGroup()

	local eventName = eventName or "vertSnapEvent"

	if( not inputObj ) then
		error("inputObj argument required for virtualJoystick")
	end

	if( interfaceLayer ) then
		interfaceLayer:insert(virtualVertSnap)
	end

	local vertSnapOutline  = ssk.proto.rect( virtualVertSnap, x, y,
		{ fill = _TRANSPARENT_, stroke = _GREY_, strokeWidth = 2, 
		  width = snapWidth, height = snapHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapOutline.alpha = 0.50

	local vertSnapDeadZone  = ssk.proto.rect( virtualVertSnap, x, y,
		{ fill = _LIGHTGREY_, stroke = _LIGHTGREY_, strokeWidth = 0, 
		   width = snapWidth-2, height = deadZoneHeight, myName = "avertSnap" }, nil, nil ) 
	vertSnapDeadZone.alpha = 0.50

	local stick  = ssk.proto.rect( virtualVertSnap, x, y,
		{ fill = _DARKGREY_, 
		  width = snapWidth, height = stickSize, myName = "avertSnap" }, nil, nil ) 

	virtualVertSnap.isVisible = false

	function virtualVertSnap:touch( event )
		local target  = event.target
		local eventID = event.id

		if(event.phase == "began") then
			display.getCurrentStage():setFocus( target, eventID )
			target.isFocus = true
			
			local newX,newY = event.x,event.y

			if( (newX + vertSnapOutline.width/2) >= w) then
				newX = w - vertSnapOutline.width/2
			end

			if( (newX - vertSnapOutline.width/2) <= 0 ) then
				newX = vertSnapOutline.width/2
			end

			if( (newY + vertSnapOutline.height/2) >= h) then
				newY = h - vertSnapOutline.height/2
			end

			if( (newY - vertSnapOutline.height/2) <= 0) then
				newY = vertSnapOutline.height/2
			end

			vertSnapOutline.x,vertSnapOutline.y = newX, newY
			vertSnapDeadZone.x,vertSnapDeadZone.y = newX, newY
			stick.x,stick.y = newX, event.y

			virtualVertSnap.isVisible = true
		end

		local vy = event.y - vertSnapOutline.y 
		local direction = "up"

		if(vy > 0) then
			direction = "down"
		end

		local magnitude = math.abs(vy)
		local maxMag = snapHeight/2
		local minMag = deadZoneHeight/2

		local percent = 0

		if(magnitude < minMag) then
			percent = 0
		elseif(magnitude > maxMag) then
			percent = 100
		else
			percent = round(magnitude/(maxMag-minMag),2) * 100
		end

		if(event.phase == "began") then

		elseif(target.isFocus) then
			if(event.phase == "ended" or event.phase == "cancelled") then
				display.getCurrentStage():setFocus( nil, eventID )
				stick.y = vertSnapOutline.y

				vy=0
				percent=0
				direction = "center"

				virtualVertSnap.isVisible = false

			elseif(event.phase == "moved") then
				stick.y = event.y
				if(percent == 100 and direction == "up" ) then
					stick.y = vertSnapOutline.y - vertSnapOutline.height/2
				elseif(percent == 100 and direction == "down" ) then
					stick.y = vertSnapOutline.y + vertSnapOutline.height/2
				end
			end
		end		

		dprint(2, direction, round(percent,2), magnitude, minMag, maxMag, (maxMag-minMag) )

		if(percent > 0 ) then
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="on", direction=direction, percent=percent })
		else
			ssk.gem:post(eventName, {phase = event.phase, vx=0, vy=vy, nx=0, ny=0, state="off", direction=direction, percent=percent })
		end

		return true
	end

	inputObj:addEventListener( "touch", virtualVertSnap )		

	function virtualVertSnap:destroy( event )
		inputObj:removeEventListener( "touch", virtualVertSnap )		
		stick:removeSelf()
		vertSnapDeadZone:removeSelf()
		vertSnapOutline:removeSelf()
	end

	return virtualVertSnap
end


return inputsFactory