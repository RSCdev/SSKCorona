-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- 2D Math Library (for operating on display objects)
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
--EFM add LERPING LIBRARY?

--local debugLevel = 1 -- Comment out to get global debugLevel from main.cs
local dp = ssk.debugprinter.newPrinter( debugLevel )
local dprint = dp.print

--[[ 
function math2do.add( objA, objB )
function math2do.sub( objA, objB )
function math2do.dot( objA, objB )
function math2do.scale( obj, s )
function math2do.normalize( obj )
function math2do.vector2Angle( objA, objB )
function math2do.tweenAngle( objA, objB )
function math2do.tweenDist( objA, objB )
function math2do.tweenData( objA, objB )

function math2do.getFacingVector( displayObject  )
--]]

--[[  NEW variant
math2d.add( objA, objB [, altRet] ) or add( x1, y1, x2, y2 [, altRet] )

function math2do.sub( objA, objB )
function math2do.dot( objA, objB )
function math2do.scale( obj, s )
function math2do.normalize( obj )
function math2do.vector2Angle( objA, objB )
function math2do.tweenAngle( objA, objB )
function math2do.tweenDist( objA, objB )
function math2do.tweenData( objA, objB )

function math2do.getFacingVector( displayObject  )
--]]


--[[
math.abs   math.acos  math.asin  math.atan math.atan2 math.ceil
math.cos   math.cosh  math.deg   math.exp  math.floor math.fmod
math.frexp math.huge  math.ldexp math.log  math.log10 math.max
math.min   math.modf  math.pi    math.pow  math.rad   math.random
math.randomseed       math.sin   math.sinh math.sqrt  math.tanh
math.tan
--]]

-- Localize math functions for speedup
local mDeg  = math.deg
local mRad  = math.rad
local mCos  = math.cos
local mSin  = math.sin
local mAcos = math.acos
local mAsin = math.asin
local mSqrt = math.sqrt
local mCeil = math.ceil
local mFloor = math.floor
local mAtan2 = math.atan2

local mPi = math.pi


local math2do = {}

-- **** 
-- **** Vector Addition
-- **** 
function math2do.add( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] + arg[3], arg[2] + arg[4]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x + arg[2].x, arg[1].y + arg[2].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end

-- **** 
-- **** Vector Subtraction
-- **** 
--EFM change me to a - b order
function math2do.sub( ... ) -- ( objA, objB [, altRet] ) or ( x1, y1, x2, y2, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[3] - arg[1], arg[4] - arg[2]

		if(arg[5]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[2].x - arg[1].x, arg[2].y - arg[1].y
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end


-- **** 
-- **** Vector dot Product
-- **** 
function math2do.dot( ... ) -- ( objA, objB ) or ( x1, y1, x2, y2 )
	local retVal = 0
	if( type(arg[1]) == "number" ) then
		retVal = arg[1] * arg[3] + arg[2] * arg[4]
	else
		retVal = arg[1].x * arg[2].x + arg[1].y * arg[2].y
	end

	return retVal
end

-- **** 
-- **** Vector length
-- **** 
function math2do.length( ... ) -- ( objA ) or ( x1, y1 )
	local len
	if( type(arg[1]) == "number" ) then
		len = mSqrt(arg[1] * arg[1] + arg[2] * arg[2])
	else
		len = mSqrt(arg[1].x + arg[1].x + arg[1].y + arg[1].y)
	end
	return len
end

-- **** 
-- **** Vector square length
-- **** 
function math2do.squarelength( ... ) -- ( objA ) or ( x1, y1 )
	local squareLen
	if( type(arg[1]) == "number" ) then
		squareLen = arg[1] * arg[1] + arg[2] * arg[2]
	else
		squareLen = arg[1].x + arg[1].x + arg[1].y + arg[1].y
	end
	return squareLen
end

-- **** 
-- **** Vector scale
-- **** 
function math2do.scale( ... ) -- ( objA, scale [, altRet] ) or ( x1, y1, scale, [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local x,y = arg[1] * arg[3], arg[2] * arg[3]

		if(arg[4]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local x,y = arg[1].x * arg[2], arg[1].y * arg[2]
			
		if(arg[3]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end

-- **** 
-- **** Vector normalize
-- **** 
function math2do.normalize( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local len = math2do.length( arg[1], arg[2], false )
		local x,y = arg[1]/len,arg[2]/len

		if(arg[3]) then
			return { x=x, y=y }
		else
			return x,y
		end
	else
		local len = math2do.length( arg[1], arg[2], true )
		local x,y = arg[1].x/len,arg[1].y/len
			
		if(arg[2]) then
			return x,y
		else
			return { x=x, y=y }
		end
	end
end


-- **** 
-- **** Vector normals
-- **** 
function math2do.normals( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		local nx1,ny1,nx2,ny2 = -arg[1], arg[2], arg[1], -arg[2]

		if(arg[3]) then
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		else
			return nx1,ny1,nx2,ny2
		end
	else
		local x,y = arg[1].x + arg[2].x, arg[1].y + arg[2].y
		local nx1,ny1,nx2,ny2 = -arg[1].x, arg[1].y, arg[1].x, -arg[1].y
			
		if(arg[2]) then
			return nx1,ny1,nx2,ny2			
		else
			return { x=nx1, y=ny1 }, { x=nx2, y=ny2 }
		end
	end
end

-- **** 
-- **** Vector to Angle
-- **** 
function math2do.vector2Angle( ... ) -- ( objA ) or ( x1, y1 )
	local angle
	if( type(arg[1]) == "number" ) then
		angle = mCeil(mAtan2( (arg[2]), (arg[1]) ) * 180 / mPi) + 90
	else
		angle = mCeil(mAtan2( (arg[1].y), (arg[1].x) ) * 180 / mPi) + 90
	end
	return angle
end

-- **** 
-- **** Angle to Vector 
-- **** 
function math2do.angle2Vector( angle, tableRet )
	local screenAngle = mRad(-(angle+90))
	local x = mCos(screenAngle) 
	local y = mSin(screenAngle) 

	if(tableRet == true) then
		return { x=-x, y=y }
	else
		return -x,y
	end
end

-- **** 
-- **** Cartesian to Screen Coordinates (and viceversa)
-- **** 
function math2do.cartesian2Screen( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end
function math2do.screen2Cartesian( ... ) -- ( objA [, altRet] ) or ( x1, y1 [, altRet]  )
	if( type(arg[1]) == "number" ) then
		if(arg[3]) then
			return { x=arg[1], y=-arg[2] }
		else
			return arg[1],-arg[2]
		end
	else
		if(arg[2]) then
			return arg[1].x,-arg[1].y
		else
			return { x=arg[1].x, y=-arg[1].y }
		end
	end
end



--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols
--EFM BELOW FUNCTIONS NEED SOME WORK TO BRING THEM IN LINE WITH alternate return protocols

-- **** 
-- **** tweenAngle - Delta between an objA and vector2Angle(objA, objB)
-- ****            - Returns vector2Angle as second return value (for cases where you need it too) :)
-- **** 
function math2do.tweenAngle( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	vx,vy            = math2do.normalize(vx,vy)
	local vecAngle   = ssk.m2d.vector2Angle(vx,vy)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)

	return tweenAngle,vecAngle
end

-- **** 
-- **** tweenDist - Distance between objA and objB (EFM fix this and others that return 'extras' to use objects not scalars)
-- ****           - Returns sub( objA, objB ) as second, third value (for cases where you need them too) :)
-- **** 
function math2do.tweenDist( objA, objB )
	local vx,vy = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local vecLen  = math2do.length(vx,vy)

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"    vecLen == " .. vecLen)

	return vecLen,vx,vy
end

-- **** 
-- **** tweenData - Returns all data between two objects (in this order)
-- ****
-- ****      vx,vy - equivalent to objMath2d.sub(objA,objB)
-- ****      nx,ny - equivalent to ssk.math2do.normalize(vx,vy)
-- ****     vecLen - equivalent to ssk.math2do.length( vx, vy )
-- ****   vecAngle - equivalent to objMath2d.vector2Angle( objA, objB)
-- **** tweenAngle - equivalent to objMath2d.tweenAngle( objA, objB)
-- **** 
function math2do.tweenData( objA, objB )
	local vx,vy      = math2do.sub( objA.x, objA.y, objB.x, objB.y )
	local nx,ny      = math2do.normalize(vx,vy)
	local vecLen     = math2do.length(vx,vy)
	local vecAngle   = math2do.vector2Angle(nx,ny)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"     nx,ny == " .. nx,ny)
	dprint(3,"    vecLen == " .. vecLen)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)			

	return vx,vy,nx,ny,vecLen,vecAngle,tweenAngle
end

function math2do.getFacingVector( displayObject  )
	local x,y =  math2do.angle2Vector( displayObject.rotation )
	return { x = x, y = y }
end

return math2do