-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Easy Sprites
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
-- Last Modified: 22 OCT 2012
-- =============================================================
--EFM integrate with future 'deferred' loading manager?

local sprite = require( "sprite" )

--[[ 
function createSpriteSet( setName, sheetSource, spriteX, spriteY, numSprites )
function createAnimationSet( setName, animName, startFrame, frameCount, time, loopParam )
function placeSprite( setName, spriteNum, x, y)
function placeAnim( setName, spriteName, x, y)
function changeSprite( theSprite, spriteNum)
--]]

local spritesFactory = {}
	spritesFactory.spriteSheets = {}

	-- ==
	-- Sprite Sheets
	-- ==

	function spritesFactory:sheetExists( sheetName )
		if( self.spriteSheets[sheetName] ) then return true end
		return false
	end

	function spritesFactory:getSheet( sheetName )
		return self.spriteSheets[sheetName]
	end

	function spritesFactory:destroySheet( sheetName )
		if( self.spriteSheets[sheetName] ) then 
			local theSheet = self.spriteSheets[sheetName]
			self.spriteSheets[sheetName] = nil
			return true 
		end
		return false
	end

	function spritesFactory:createSheet( sheetName, sheetImg, sheetParams )
		if( not self.spriteSheets[sheetName] ) then 

			self.spriteSheets[sheetName] = graphics.newImageSheet( sheetImg, sheetParams )

			return self.spriteSheets[sheetName]
		end
		print("ERROR: f_sprites: spritesFactory:createSheet( " .. sheetName .. " ) -- Already exists! " )
		return nil
	end



--[[
	spritesFactory.spriteSets = {}
	spritesFactory.animations = {}

	function spritesFactory:createSpriteSet( setName, sheetSource, spriteX, spriteY, numSprites )
		self.spriteSheets[setName] = sprite.newSpriteSheet(sheetSource, spriteX, spriteY)

		self.spriteSets[setName]   = sprite.newSpriteSet(self.spriteSheets[setName], 1, numSprites)
		for i = 1, numSprites do
			sprite.add( self.spriteSets[setName], setName .. i, i,1,1000,0)
		end
	end

	function spritesFactory:createAnimationSet( setName, animName, startFrame, frameCount, time, loopParam )
		sprite.add( self.spriteSets[setName], animName, startFrame, frameCount, time, loopParam)
	end

	function spritesFactory:placeSprite( setName, spriteNum, x, y)
		local x = x or 0
		local y = y or 1

		local localSprite = sprite.newSprite ( self.spriteSets[setName] )	
		localSprite.x = x
		localSprite.y = y

		localSprite:prepare(setName .. spriteNum)
		localSprite:pause()

		localSprite.mySetName   = setName
		localSprite.mySpriteNum = spriteNum

		--EFM add isa()

		return localSprite
	end

	function spritesFactory:placeAnim( setName, spriteName, x, y)
		local x = x or 0
		local y = y or 1

		local localSprite = sprite.newSprite ( self.spriteSets[setName] )	
		localSprite.x = x
		localSprite.y = y

		localSprite:prepare( spriteName )
		localSprite:play()

		localSprite.mySetName   = setName

		--EFM add isa()

		return localSprite
	end

	function spritesFactory:changeSprite( theSprite, spriteNum)
		local localSprite = theSprite

		localSprite:prepare(localSprite.mySetName  .. spriteNum)
		localSprite:play()

		return localSprite
	end
--]]
return spritesFactory
