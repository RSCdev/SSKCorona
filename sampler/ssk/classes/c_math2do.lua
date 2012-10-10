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

local m2d = require( "ssk.classes.c_math2d" )       -- 2D Math


local math2do = {}

-- **** 
-- **** Vector Addition
-- **** 
function math2do.add( objA, objB )
	local tmpTable = {}
	tmpTable.x,tmpTable.y = m2d.add(objA.x, objA.y, objB.x, objB.y)
	return tmpTable
end

-- **** 
-- **** Vector Subtraction
-- **** 
function math2do.sub( objA, objB )
	local tmpTable = {}
	tmpTable.x,tmpTable.y = m2d.sub(objA.x, objA.y, objB.x, objB.y)
	return tmpTable
end

-- **** 
-- **** Vector dot Product
-- **** 
function math2do.dot( objA, objB )
	return  m2d.dot(objA.x, objA.y, objB.x, objB.y)
end

---EFM ADD VECTOR LERP

-- **** 
-- **** Vector scale
-- **** 
function math2do.scale( obj, s )
	local tmpTable = {}
	tmpTable.x,tmpTable.y = m2d.scale(obj.x,obj.y, s)
	return tmpTable
end

-- **** 
-- **** Vector normalize
-- **** 
function math2do.normalize( obj )
	local tmpTable = {}
	tmpTable.x,tmpTable.y = m2d.normalize(obj.x,obj.y)
	return tmpTable
end


-- **** 
-- **** Vector normals
-- **** 
function math2do.normals( obj )
	local tmpTable = {}
	tmpTable.x,tmpTable.y = m2d.normals(obj.x,obj.y)
	return tmpTable
end

-- **** 
-- **** vector2Angle - Angle between object A and B
-- **** 
function math2do.vector2Angle( objA, objB )
	local vx,vy      = m2d.sub( objA.x, objA.y, objB.x, objB.y )
	vx,vy            = m2d.normalize(vx,vy)
	local vecAngle   = m2d.vector2Angle(vx,vy)

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"  vecAngle == " .. vecAngle)

	return vecAngle
end

-- **** 
-- **** Angle to Vector (Operates in Cartesian Coordinate System) --EFM verify this
-- **** 
function math2do.angle2Vector( angle )
	local tmpTable = {}
	local math = math
	local screenAngle = mRad(-(angle+90))
	x = mCos(screenAngle) 
	y = mSin(screenAngle) 

	tmpTable.x = -x
	tmpTable.y = y
	return tmpTable
end


-- **** 
-- **** tweenAngle - Delta between an objA and vector2Angle(objA, objB)
-- ****            - Returns vector2Angle as second return value (for cases where you need it too) :)
-- **** 
function math2do.tweenAngle( objA, objB )
	local vx,vy      = m2d.sub( objA.x, objA.y, objB.x, objB.y )
	vx,vy            = m2d.normalize(vx,vy)
	local vecAngle   = m2d.vector2Angle(vx,vy)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)

	return tweenAngle,vecAngle
end

-- **** 
-- **** tweenDist - Distance between objA and objB
-- ****           - Returns sub( objA, objB ) as second, third value (for cases where you need them too) :)
-- **** 
function math2do.tweenDist( objA, objB )
	local vx,vy = m2d.sub( objA.x, objA.y, objB.x, objB.y )
	local vecLen  = m2d.length(vx,vy)

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"    vecLen == " .. vecLen)

	return vecLen,vx,vy
end

-- **** 
-- **** tweenData - Returns all data between two objects (in this order)
-- ****
-- ****      vx,vy - equivalent to objMath2d.sub(objA,objB)
-- ****      nx,ny - equivalent to ssk.m2d.normalize(vx,vy)
-- ****     vecLen - equivalent to ssk.m2d.length( vx, vy )
-- ****   vecAngle - equivalent to objMath2d.vector2Angle( objA, objB)
-- **** tweenAngle - equivalent to objMath2d.tweenAngle( objA, objB)
-- **** 
function math2do.tweenData( objA, objB )
	local vx,vy      = m2d.sub( objA.x, objA.y, objB.x, objB.y )
	local nx,ny      = m2d.normalize(vx,vy)
	local vecLen     = m2d.length(vx,vy)
	local vecAngle   = m2d.vector2Angle(nx,ny)
	local tweenAngle = vecAngle - objA.rotation

	dprint(3,"     vx,vy == " .. vx,vy)
	dprint(3,"     nx,ny == " .. nx,ny)
	dprint(3,"    vecLen == " .. vecLen)
	dprint(3,"  vecAngle == " .. vecAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)
	dprint(3,"tweenAngle == " .. tweenAngle)			

	return vx,vy,nx,ny,vecLen,vecAngle,tweenAngle
end
return math2do