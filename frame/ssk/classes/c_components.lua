-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Game Logic Modules
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

local components = {}

-- ================================================================
-- ================================================================
-- ==						FACING
-- ================================================================
-- ================================================================

-- ===============================================
-- ==           FACE POINT
-- ===============================================
-- dps => degrees per second
function components.transition_facePoint( obj, x, y, dps, easing )
	local px = x
	local py = y	
	local dps = dps or 0
	dps = dps/1000
	local easing = easing or transition.linear

	local tweenAngle, vecAngle = ssk.m2do.tweenAngle( obj, {x=px,y=py} )

	-- Instant Turn
	if(dps <=0 ) then
		obj.rotation = vecAngle

	-- Timed Turn
	else
		if(tweenAngle >= 180) then
			vecAngle = vecAngle - 360
			tweenAngle  = vecAngle - obj.rotation
		elseif(tweenAngle <= -180) then
			vecAngle = vecAngle + 360
			tweenAngle  = vecAngle - obj.rotation
		end	

		local rotateTime = math.abs(round(tweenAngle / dps))

		transition.to( obj, { rotation = vecAngle, time = rotateTime, transition = easing } )
	end
end
-- ===============================================
-- ==           FACE OBJECT
-- ===============================================
function components.transition_faceObject( objA, objB, dps, easing )
	components.transition_facePoint( objA, objB.x, objB.y, dps, easing )
end


-- ================================================================
-- ================================================================
-- ==						MOVING
-- ================================================================
-- ================================================================

-- ===============================================
-- ==           MOVE TO POINT
-- ===============================================
-- pps => pixels per second
function components.transition_moveToPoint( obj, x, y, pps, easing )
	local px = x
	local py = y	
	local pps = pps or 0
	pps = pps/1000
	local easing = easing or transition.linear

	-- Instant Move
	if(pps <=0 ) then
		obj.x,obj.y = px,py

	-- Timed Move
	else
		local vecLen,vx,vy = ssk.m2do.tweenDist( obj, {x=px,y=py} ) 
		local moveTime = round(vecLen / pps)
		transition.to( obj, { x = px, y = py, time = moveTime, transition = easing } )
	end
end

-- ===============================================
-- ==           MOVE TO OBJECT
-- ===============================================
function components.transition_moveToObject( objA, objB, pps, easing )
	components.transition_moveToPoint( objA, objB.x, objB.y, pps, easing )
end



-- ================================================================
-- ================================================================
-- ==						SEEKING & AIMING
-- ================================================================
-- ================================================================

-- ===============================================
-- ==           SEEK OBJECT
-- ===============================================
-- seekTest: Test one object to see if it matches the search criteria
-- Note: Passing nil for 'maxDist' and 'maxAngle' will automatically
-- return true or any 'objB'. i.e. With no dist or angle test, the object
-- is always 'found'
function components.seekTest(objA, objB, maxDist, maxAngle )

	local vx,vy,nx,ny,vecLen,vecAngle,tweenAngle = ssk.m2do.tweenData( objA, objB )

	if(maxDist) then
		if(vecLen >= maxDist) then
			return false
		end
	end

	if( maxAngle ) then
		if(tweenAngle >= 360) then
			tweenAngle = tweenAngle - 360
		end
		tweenAngle = math.abs( tweenAngle )
	end

	return true
end

function components.seekObject( objA, targetTable, maxDist, maxAngle)
	local seekPeriod = seekPeriod or 100
	-- Note: No search order is guaranteed, but this works for all tables of
	-- targets, regardless of index scheme
	for k,v in pairs(targetTable) do
		if( components.seekTest( objA, v, maxDist, maxAngle ) )then
			return v
		end
	end
	return nil
end


-- ===============================================
-- ==           AIM AT OBJECT
-- ===============================================
function components.aimAtObject( objA, target, period, onLoseCB )

	-- Catch case where aiming object was removed before delayed call occured
	if( not objA.x ) then
		return
	end

	if( not target.x ) then
		if(onLoseCB) then
			onLoseCB( objA, nil, "destroyed" )
		end
		return
	end

	local vecAngle = ssk.m2do.vector2Angle( objA, target )

	objA.rotation = vecAngle

	local closure = function()
		components.aimAtObject( objA, target, period, onLoseCB )		
	end

	timer.performWithDelay( period, closure )
end

-- ===============================================
-- ==           AIM AT OBJECT MAX DIST
-- ===============================================
function components.aimAtObjectMaxDist( objA, target, period, maxDist, onLoseCB, reseek )

	-- Catch case where aiming object was removed before delayed call occured
	if( not objA.x ) then
		return
	end

	if( not target.x ) then
		if(onLoseCB) then
			onLoseCB( objA, nil, "destroyed" )
		end
		return
	end

	local vecAngle     = ssk.m2do.vector2Angle( objA, target )
	local vecLen,vx,vy = ssk.m2do.tweenDist( objA, target )
	--print("vecLen == " .. vecLen, tostring(reseek)) 

	local closure = function()
		components.aimAtObjectMaxDist( objA, target, period, maxDist, onLoseCB, reseek )
	end

	if(vecLen >= maxDist) then
		if(onLoseCB) then
			onLoseCB( objA, target, "distance" )
		end

		if(reseek) then 
			timer.performWithDelay( period, closure )			
		end
		return
	end

	objA.rotation = vecAngle

	timer.performWithDelay( period, closure )
end

-- ===============================================
-- ==          Caclulate Wrap Point
-- ===============================================
function components.calculateWrapPoint( objectToWrap, wrapRectangle )
	local right = wrapRectangle.x + wrapRectangle.width / 2
	local left  = wrapRectangle.x - wrapRectangle.width / 2

	local top = wrapRectangle.y - wrapRectangle.height / 2
	local bot  = wrapRectangle.y + wrapRectangle.height / 2

	if(objectToWrap.x >= right) then
		objectToWrap.x = left
	elseif(objectToWrap.x <= left) then 
		objectToWrap.x = right
	end

	if(objectToWrap.y >= bot) then
		objectToWrap.y = top
	elseif(objectToWrap.y <= top) then 
		objectToWrap.y = bot
	end
end



--EFM
-- ================================================================
-- ================================================================
-- ==						XXXXX
-- ================================================================
-- ================================================================


return components