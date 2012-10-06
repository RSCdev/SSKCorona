-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- 2D Math Library
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
function add( x1, y1, x2, y2 )
function sub( x1, y1, x2, y2 )
function dot( x1, y1, x2, y2 )
function length( x, y )
function scale( x, y, s )
function normalize( x, y )
function vector2Angle( x, y )
function angle2Vector( angle )
function cartesian2Screen( x,y )
function screen2Cartesian( x,y )
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

local math2d = {}

-- **** 
-- **** Vector Addition
-- **** 
function math2d.add( x1, y1, x2, y2 )
	return x2 + x1, y2 + y1
end

-- **** 
-- **** Vector Subtraction
-- **** 
function math2d.sub( fromX, fromY, toX, toY )
	return toX - fromX, toY - fromY
end

-- **** 
-- **** Vector dot Product
-- **** 
function math2d.dot( x1, y1, x2, y2 )
	return x2 * x1, y2 * y1
end


-- **** 
-- **** Vector length
-- **** 
function math2d.length( x, y )
	return mSqrt( x * x + y * y )
end

-- **** 
-- **** Vector scale
-- **** 
function math2d.scale( x, y, s )
	return x * s, y * s
end

-- **** 
-- **** Vector normalize
-- **** 
function math2d.normalize( x, y )
	len = math2d.length( x , y )
	xNorm = x / len
	yNorm = y / len
	return xNorm,yNorm
end

-- **** 
-- **** Vector to Angle (Operates in Screen Coordinate System)
-- **** 
function math2d.vector2Angle( x, y )
	local angle = mCeil(mAtan2( (y), (x) ) * 180 / mPi) + 90
	if(angle < 0) then angle = angle + 360 end
	return angle
end

-- **** 
-- **** Angle to Vector (Operates in Cartesian Coordinate System) --EFM verify this
-- **** 
function math2d.angle2Vector( angle )
	local math = math
	local screenAngle = mRad(-(angle+90))
	x = mCos(screenAngle) 
	y = mSin(screenAngle) 
	return -x,y
end

-- **** 
-- **** Cartesian to Screen Coordinates (and viceversa)
-- **** 
function math2d.cartesian2Screen( x,y )
	return x,-y
end
function math2d.screen2Cartesian( x,y )
	return x,-y
end


return math2d