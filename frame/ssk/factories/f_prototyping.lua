-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Prototyping Objects
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

--EFM Add spriteRect, and spriteCircle too

--[[ 

backImage()  - Add a background tray (image) to a group.

quitButton() - Add a 'quit' button in upper right corner of screen

arrowhead( group, x, y, width, height, [visualParams])
arrow( group, startX, startY, endX, endY, visualParams )
arrow2( group, startX, startY, angle, length, visualParams)

line( group, startX, startY, endX, endY, dashLen, gapLen, visualParams ) 
line2( group, startX, startY, angle, dashLen, gapLen, visualParams )
segmentedLine( group, points, visualParams )

rect( group, x, y, [ [visualParams], [ [bodyParams], [behaviorsList] ] ])
circle( group, x, y, [ [visualParams], [ [bodyParams], [behaviorsList] ] ])
imageRect( group, x, y, imgSrc, [ [visualParams], [ [bodyParams], [behaviorsList] ] ])
imageCircle( group, x, y, imgSrc, [ [visualParams], [ [bodyParams], [behaviorsList] ] ])
 -- obj.getColliderName = function(self) return myColliderName end

listDPP()
getDPP = function(name)
setDPP = function(name)

quickLayers( parentGroup,  ... )
--]]

--
-- variables
--
local dpp
--
-- local functions (only used internally)
--
local initDPP
local addBody 
local addBehaviors

local protoFactory = {}

function protoFactory.backImage( group, imageFile )
	local imageFile = imageFile or "protoBack.png"
	local image = display.newImage( imagesDir .. "interface/" .. imageFile )
	group:insert( image, true )
	image.x = w/2
	image.y = h/2
	if(system.orientation == "landscapeRight") then
		image.rotation = 90
	end
	return image
end

function display.backImage( group, imageFile )
	local imageFile = imageFile or "protoBack.png"
	local image = display.newImage( imagesDir .. "interface/" .. imageFile )
	group:insert( image, true )
	image.x = w/2
	image.y = h/2
	if(system.orientation == "landscapeRight") then
		image.rotation = 90
	end
	return image
end


function protoFactory.quitButton( callback, group )
	local quitButton = ssk.buttons:new 
	{
		unselImg = imagesDir .. "homeButtonRed.png",
		selImg = imagesDir .. "homeButtonRedOver.png",
		x = w-16,
		y = 16,
		w = 32,
		h = 32,
		fontSize = 30,
		onRelease = callback,
		text = "",
		scaleFont = true,
		textOffset = {0,0},
	}
	group:insert(quitButton)

	return quitButton
end

--EFM buggy with regards to rotated arrow heads (test all uses)
function protoFactory.arrowhead( group, x, y, width, height, visualParams )
	local halfWidth  = width/2
	local halfHeight = height/2

	local head = display.newLine( x,            y + halfHeight, 
	                              x - halfWidth, y + halfHeight )

	head:append( x            , y - halfHeight, 
                 x + halfWidth, y + halfHeight,
				 x,            y + halfHeight )
	
	head.width = visualParams.width or 1
	
	if(visualParams.color) then
		head:setColor( unpack(visualParams.color))
	end

	if(visualParams.rotation) then
		head.x = 0
		head.y = 0
		head.rotation = visualParams.rotation
		head.x, head.y = x,y
	end

	group:insert( head )

	return head
end

function protoFactory.arrow( group, startX, startY, endX, endY, visualParams )
	local arrow = display.newGroup()
	
	group:insert(arrow)

	local vx,vy  = ssk.m2d.sub(startX, startY, endX, endY)

	local vLen  = ssk.m2d.length(vx,vy)

	local nx,ny = ssk.m2d.normalize(vx,vy)

	local cx,cy = ssk.m2d.scale(nx,ny, vLen/2)
	cx,cy = ssk.m2d.add(startX, startY, cx, cy)
	
	local rotation = ssk.m2d.vector2Angle(vx,vy)	
	
	local arrowLine = display.newLine( startX, startY, endX, endY )
	
	local width = 1
	local color = _WHITE_

	local headHeight = 10

	if( visualParams ) then
		width = visualParams.width or 1
	
		if(visualParams.color) then
			color = visualParams.color 
		end

		if(visualParams.headHeight) then
			headHeight = visualParams.headHeight 
		end

	end

	arrowLine:setColor( unpack(color))

	local arrowhead = protoFactory.arrowhead( arrow, 0, 0, headHeight, headHeight, 
	                                         {color = color, 
											 rotation = rotation, 
											 width = width })
    -- remember, rotate then translate for correct result!
	arrowhead.x = endX 
	arrowhead.y = endY 

	arrow.head = arrowhead
	
	arrow.angle = rotation

	arrow.vx = vx
	arrow.vy = vy

	arrow.cx = cx
	arrow.cy = cy

	arrow:insert( arrowLine )

	return arrow
end

function protoFactory.arrow2( group, startX, startY, angle, length, visualParams)

	local endX, endY = ssk.m2d.angle2Vector( angle )
	endX, endY = ssk.m2d.scale( endX, endY, length )
	endX, endY = ssk.m2d.add(startX, startY, endX, endY)

	return protoFactory.arrow( group, startX, startY, endX, endY, visualParams )

end

function protoFactory.line( group, startX, startY, endX, endY, dashLen, gapLen, visualParams )
	
	local theLine = display.newGroup()
	group:insert( theLine )

	local vx,vy    = ssk.m2d.sub(startX, startY, endX, endY)
	local vLen     = ssk.m2d.length(vx,vy)
	local nx,ny    = ssk.m2d.normalize(vx,vy)
	local cx,cy    = ssk.m2d.scale(nx,ny, vLen/2)
	      cx,cy    = ssk.m2d.add(startX, startY, cx, cy)
	local rotation = ssk.m2d.vector2Angle(vx,vy)	

	theLine.vx = vx
	theLine.vy = vy
	theLine.cx = cx
	theLine.cy = cy
	theLine.angle = rotation

	if(visualParams) then
		theLine.style = visualParams.style or "solid"
	else
		theLine.style = "solid"
	end

	if(theLine.style == "solid") then
		local width = 1 
		local color = _WHITE_

		if( visualParams ) then
			width = visualParams.width or 1
	
			if(visualParams.color) then
				color = visualParams.color 
			end
		end

		local aDash = display.newLine( startX, startY, endX, endY )
		theLine:insert(aDash)
		aDash.width = width
		aDash:setColor( unpack(color) )


	elseif(theLine.style == "dashed") then
		local dash_dx,dash_dy = ssk.m2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = ssk.m2d.scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = ssk.m2d.scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		local width = 1 
		local color = _WHITE_

		if( visualParams ) then
			width = visualParams.width or 1
	
			if(visualParams.color) then
				color = visualParams.color 
			end
		end

		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = ssk.m2d.add( curX, curY, dash_dx, dash_dy )
				local aDash = display.newLine( curX, curY, newX, newY )
				theLine:insert(aDash)
				aDash.width = width
				aDash:setColor( unpack(color) )
			
				curX,curY = newX,newY

			end

			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.m2d.add( curX, curY, gap_dx, gap_dy )
		end

	elseif(theLine.style == "dotted") then
		local dot_dx,dot_dy = ssk.m2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dot_dx,dot_dy
	
		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0
		local radius
		local color = _WHITE_
		local strokeColor = _WHITE_
		local strokeWidth = 0

		if( visualParams ) then
			radius = visualParams.width/2 or 1
			if(radius<1) then radius = 1 end
	
			if(visualParams.color) then
				color = visualParams.color 
			end

			if(visualParams.stroke) then 
				strokeColor = visualParams.stroke
				strokeWidth = 1
			end
			if( visualParams.strokeWidth ) then strokeWidth = visualParams.strokeWidth end
		end


		dot_dx,dot_dy       = ssk.m2d.scale(dot_dx,dot_dy, radius*2)
		gap_dx,gap_dy         = ssk.m2d.scale(gap_dx,gap_dy, gapLen)

		while( lineLen < vLen ) do
			-- Attempt to draw a dot
			lineLen = lineLen + radius*2
			if( lineLen < vLen ) then
				newX,newY = ssk.m2d.add( curX, curY, dot_dx, dot_dy )
				local adot = display.newCircle( theLine, curX, curY, radius )

				adot:setFillColor( unpack(color) )
				adot:setStrokeColor( unpack(strokeColor) ) 
				adot.strokeWidth = strokeWidth


				curX,curY = newX,newY

			end

			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.m2d.add( curX, curY, gap_dx, gap_dy )
		end


	elseif(theLine.style == "arrows") then
		local dash_dx,dash_dy = ssk.m2d.normalize(vx, vy)
		local gap_dx,gap_dy   = dash_dx,dash_dy
	
		dash_dx,dash_dy       = ssk.m2d.scale(dash_dx,dash_dy, dashLen)
		gap_dx,gap_dy         = ssk.m2d.scale(gap_dx,gap_dy, gapLen)

		local lineLen = 0
		local curX, curY = startX,startY
		local newX, newY = 0,0

		while( lineLen < vLen ) do
			-- Attempt to draw a dash
			lineLen = lineLen + dashLen
			if( lineLen < vLen ) then
				newX,newY = ssk.m2d.add( curX, curY, dash_dx, dash_dy )
				local aDash = protoFactory.arrow( group, curX, curY, newX,newY, visualParams )
				theLine:insert(aDash)
			
				curX,curY = newX,newY

			end

			-- Add a gap
			lineLen = lineLen + gapLen
			curX,curY = ssk.m2d.add( curX, curY, gap_dx, gap_dy )
		end
	end

	return theLine
end

function protoFactory.line2( group, startX, startY, angle, length, dashLen, gapLen, visualParams )
	local endX, endY = ssk.m2d.angle2Vector( angle )
	endX, endY = ssk.m2d.scale( endX, endY, length )
	endX, endY = ssk.m2d.add(startX, startY, endX, endY)
	return protoFactory.line( group, startX, startY, endX, endY, dashLen, gapLen, visualParams )
end

--EFM add ability to append new segments
--EFM add arrowcapped style (single end arrowhead)
function protoFactory.segmentedLine( group, points, visualParams )
	local theLine = display.newGroup()
	group:insert( theLine )


	if(visualParams) then
		theLine.style = visualParams.style or "solid"
	else
		theLine.style = "solid"
	end

	if(theLine.style == "solid") then
		local width = 1
		local color = _WHITE_

		if( visualParams ) then
			width = visualParams.width or 1
	
			if(visualParams.color) then
				color = visualParams.color 
			end
		end

		if( #points > 1 ) then
			local tmpLine = nil
			for i = 2, #points do
				if( i == 2) then
					local a = points:get(1)
					local b = points:get(2)
					tmpLine = display.newLine( a.x, a.y, b.x, b.y )
				else
					local a = points:get(i)
					tmpLine:append( a.x, a.y )
				end
			end
			theLine:insert(tmpLine)
			tmpLine.width = width
			tmpLine:setColor( unpack(color) )
		end


	elseif(theLine.style == "dashed") then
		local width = 1
		local color = _WHITE_

		if( visualParams ) then
			width = visualParams.width or 1
	
			if(visualParams.color) then
				color = visualParams.color 
			end
		end

		local tmpLine = nil
		for i = 2, #points do
			if( i % 2 == 0) then
				local a = points:get(i-1)
				local b = points:get(i)
				tmpLine = display.newLine( a.x, a.y, b.x, b.y )

				theLine:insert(tmpLine)
				tmpLine.width = width
				tmpLine:setColor( unpack(color) )
			end
		end

	elseif(theLine.style == "dotted") then
		local radius = 1
		local color = _WHITE_
		local strokeColor = _WHITE_
		local strokeWidth = 0

		if( visualParams ) then
			radius = visualParams.width/2 or 1
			if(radius<1) then radius = 1 end
	
			if(visualParams.color) then
				color = visualParams.color 
			end

			if(visualParams.stroke) then 
				strokeColor = visualParams.stroke
				strokeWidth = 1
			end
			if( visualParams.strokeWidth ) then strokeWidth = visualParams.strokeWidth end
		end

		for i = 1, #points do
			local a = points:get(i)
			local tmpDot = display.newCircle( theLine, a.x, a.y, radius )

			tmpDot:setFillColor( unpack(color) )
			tmpDot:setStrokeColor( unpack(strokeColor) ) 
			tmpDot.strokeWidth = strokeWidth
		end


	elseif(theLine.style == "arrowheads") then  --EFM BUG arrowheads are offset!
		local size = 10
		local color = _WHITE_
		local strokeColor = _WHITE_

		if( visualParams ) then
			size = visualParams.size or 10
	
			if(visualParams.color) then
				color = visualParams.color 
			end
		end

		visualParams.rotation = 0

		for i = 1, #points do			
			local a = points:get(i)

			if(#points >= i+1) then
				local b = points:get(i+1)

				local nVec = ssk.m2do.sub(a,b)
				nVec = ssk.m2do.normalize( nVec )
				local angle = ssk.m2do.vector2Angle(nVec)
				visualParams.rotation = angle
			end

			local tmpArrowHead = protoFactory.arrowhead( theLine, a.x, a.y, size, size, visualParams )
		end
	end


	return theLine
end


function protoFactory.rect( group, x, y, visualParams, bodyParams, behaviorsList )

	local width = 40
	local height = 40

	if(visualParams) then
		if( visualParams.size ) then
			width = visualParams.size
			height = visualParams.size
		end

		if( visualParams.width ) then
			width = visualParams.width
		end
		if( visualParams.height ) then
			height = visualParams.height
		end
	end

	local dObj = display.newRect( group, 0, 0, width, height )

	dObj.x = x
	dObj.y = y

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params
	end

	if(bodyParams) then addBody(dObj, bodyParams) end
	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

function protoFactory.circle( group, x, y, visualParams, bodyParams, behaviorsList )

	local radius = 40
	if(visualParams) then
		if( visualParams.size ) then
			radius = visualParams.size/2
		end
		if( visualParams.radius ) then
			radius = visualParams.radius
		end
		if( visualParams.diameter ) then
			radius = visualParams.diameter/2
		end
	end

	local dObj = display.newCircle( group, x, y, radius )

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params
	end

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

function protoFactory.imageRect( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )

	local width = 40
	local height = 40

	if(visualParams) then
		if( visualParams.size ) then
			width = visualParams.size
			height = visualParams.size
		end

		if( visualParams.width ) then
			width = visualParams.width
		end
		if( visualParams.height ) then
			height = visualParams.height
		end
	end

	local dObj = display.newImageRect( group, imgSrc, width, height )

	dObj.x = x
	dObj.y = y

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params
	end

	if(bodyParams) then addBody(dObj, bodyParams) end
	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end

function protoFactory.imageCircle( group, x, y, imgSrc, visualParams, bodyParams, behaviorsList )

	local radius = 40

	if(visualParams) then
		if( visualParams.size ) then
			radius = visualParams.size/2
		end
		if( visualParams.radius ) then
			radius = visualParams.radius
		end
		if( visualParams.diameter ) then
			radius = visualParams.diameter
		end
	end

	local dObj = display.newImageRect( group, imgSrc, radius*2, radius*2 )
	dObj.x = x
	dObj.y = y

	if(visualParams) then
		if(visualParams.fill) then dObj:setFillColor( unpack(visualParams.fill) ) end
		if(visualParams.stroke) then 
			dObj:setStrokeColor( unpack(visualParams.stroke) ) 
			dObj.strokeWidth = 1
		end
		if( visualParams.strokeWidth ) then dObj.strokeWidth = visualParams.strokeWidth end

		if( visualParams.myName ) then dObj.myName = visualParams.myName end -- debug params
	end

	if(bodyParams) then 
		local bodyParams = table.shallowCopy(bodyParams)
		bodyParams.radius = radius
		addBody(dObj, bodyParams) 
	end

	if(behaviorsList) then addBehaviors(dObj, behaviorsList) end

	return dObj
end



initDPP = function()
	dpp = {}
	-- Basic settings
	dpp.bodyType = "dynamic"
	dpp.bounce   = 0.2
	dpp.density  = 1.0
	dpp.friction = 0.3

	-- Extra Settings
	dpp.angularDamping     = 0
	dpp.isBodyActive       = true
	dpp.isBullet           = false
	dpp.isFixedRotation    = false
	dpp.isSensor           = false
	dpp.isSleepingAllowed  = true
	dpp.linearDamping      = 0
end

function protoFactory.listDPP()
	print("g_prototyping.lua => dpp (Default Physical Params):")
	for k,v in pairs(dpp) do
		print( tostring(k):rpad(20) .. " == ", tostring(v) )
	end
	print("\n")
end


function protoFactory.getDPP(name)
	return dpp[name]
end

function protoFactory.setDPP(name,value)
	dpp[name] = value
end

addBody = function( obj, bodyParams )

	-- Copy basic body params into local params	
	local params = {}
	local paramNames = { "bounce", "density", "friction", "shape", "radius", "filter" }
	for k,v in ipairs( paramNames ) do
		params[v] = fnn(bodyParams[v], dpp[v])
	end

	-- Optionally get a collision filter
	local theCalculator
	if(bodyParams.calculator) then
		theCalculator = bodyParams.calculator
	else
		theCalculator = collisionCalculator
	end

	if(bodyParams.colliderName) then
		local myColliderName = bodyParams.colliderName
		local collisionFilter = theCalculator:getCollisionFilter( myColliderName )
		params.filter=collisionFilter		
		obj.getColliderName = function(self) return myColliderName end
	end

	-- add the body (square or circular)
	physics.addBody( obj, params )

	-- set any remaining parameters
	local paramNames = { "bodyType", "angularDamping", "isBodyActive", "isBullet", 
	                     "isFixedRotation", "isSensor", "isSleepingAllowed", "linearDamping" }
	for k,v in ipairs( paramNames ) do
		obj[v] = fnn(bodyParams[v], dpp[v])
	end
	
end

addBehaviors = function( obj, behaviorsList )
	for k,v in ipairs( behaviorsList ) do
		local valueType = type(v)
			
		if( valueType == "string" ) then
			dprint(2,"attach string variant")
			ssk.behaviors:attachBehavior(obj, v)
		elseif( valueType == "table" ) then
			dprint(2,"attach table variant")
			ssk.behaviors:attachBehavior(obj, v[1], v[2] )
		else
			error("u_prototyping.lua:addBehaviors() => Unknown type: " .. valueType)
		end
		
	end
end

function protoFactory.quickLayers( parentGroup, ... )

	local layers = display.newGroup() 
	parentGroup:insert(layers)

	layers._db = {}

	local lastGroup

	dprint(1,"\\ (parentGroup)")
	
	for i = 1, #arg do
		local theArg = arg[i]
			
		if(type(theArg) == "string") then
			dprint(1,"|--\\ " .. theArg)
			local group = display.newGroup()
			lastGroup = group
			layers._db[#layers._db+1] = group 
			layers[theArg] = group 
			parentGroup:insert( group )

		else -- Must be a table -- ALLOW UP TO 'ONE' ADDITIONAL LEVEL OF DEPTH
			for j = 1, #theArg do
				local theArg2 = theArg[j]
				dprint(1,"   |--\\ " .. theArg2)
				if(type(theArg2) == "string") then
					local group = display.newGroup()
					layers._db[#layers._db+1] = group 
					layers[theArg2] = group 
					lastGroup:insert( group )
				else
					error("layers() Only two levels allowed!")
				end				
			end
		end		
	end

	function layers:destroy()
		for i = #self._db, 1, -1 do
			dprint(2,"quickLayers(): Removing layer: " .. i)
			self._db[i]:removeSelf()
		end
		self:removeSelf()
	end
	
	return layers	
end

initDPP()

return protoFactory