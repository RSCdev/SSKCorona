-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Collision Calculator - Used to set up collisions using 'names' instead of numbers.
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

collisionsCalculatorManger = {}
	function collisionsCalculatorManger:newCalculator()

		collisionsCalculator = {}

		collisionsCalculator._colliderNum = {}
		collisionsCalculator._colliderCategoryBits = {}
		collisionsCalculator._colliderMaskBits = {}
		collisionsCalculator._knownCollidersCount = 0

		-- 
		-- Add new 'named' collider type to known list of collider types, and
		-- automatically assign a number to this collider type (16 Max).
		--
		function collisionsCalculator:addName( colliderName )

			if(not self._colliderNum[colliderName]) then
				-- Be sure we don't create more than 16 named collider types
				if( self._knownCollidersCount == 16 ) then
					return false
				end		

				local newColliderNum = self._knownCollidersCount + 1
		
				self._knownCollidersCount = newColliderNum
				self._colliderNum[colliderName] = newColliderNum
				self._colliderCategoryBits[colliderName] = 2 ^ (newColliderNum - 1)
				self._colliderMaskBits[colliderName] = 0
			end

			return true
		end

		-- PRIVATE - DO NOT USE IN YOUR GAME CODE
		function collisionsCalculator:configureCollision( colliderNameA, colliderNameB )
			--
			-- Verify both colliders exist before attempting to configure them:
			--
			if( not self._colliderNum[colliderNameA] ) then
				print("Error: collidesWith() - Unknown collider: " .. colliderNameA)
				return false
			end
			if( not self._colliderNum[colliderNameB] ) then
				print("Error: collidesWith() - Unknown collider: " .. colliderNameB)
				return false
			end
		
			-- Add the CategoryBit for A to B's collider mask and vice versa
			-- Note: The if() statements encapsulating this setup work ensure
			--       that the faked bitwise operation is only done once 
			local colliderCategoryBitA = self._colliderCategoryBits[colliderNameA]
			local colliderCategoryBitB = self._colliderCategoryBits[colliderNameB]
			if( (self._colliderMaskBits[colliderNameA] % (2 * colliderCategoryBitB) ) < colliderCategoryBitB ) then
				self._colliderMaskBits[colliderNameA] = self._colliderMaskBits[colliderNameA] + colliderCategoryBitB
			end
			if( (self._colliderMaskBits[colliderNameB] % (2 * colliderCategoryBitA) ) < colliderCategoryBitA ) then
				self._colliderMaskBits[colliderNameB] = self._colliderMaskBits[colliderNameB] + colliderCategoryBitA
			end

			return true
		end


		--
		-- Automatically configure named collider A to collide with one or more other named
		-- colliders
		function collisionsCalculator:collidesWith( colliderNameA, ... )
			for key, value in ipairs(arg) do
        		self:configureCollision( colliderNameA, value )
			end
		end

		--
		-- Get category bits for the named collider
		--
		function collisionsCalculator:getCategoryBits( colliderName )
			return self._colliderMaskBits[colliderName] 
		end

		--
		-- Get mask bits for the named collider
		--
		function collisionsCalculator:getMaskBits( colliderName )
			return self._colliderCategoryBits[colliderName] 
		end

		--
		-- Get collision filter for the named collider
		--
		function collisionsCalculator:getCollisionFilter( colliderName )
			local collisionFilter =  
			{ 
	   		categoryBits = self._colliderCategoryBits[colliderName],
	   		maskBits     = self._colliderMaskBits[colliderName], 
			}  

			return collisionFilter
		end


		-- 
		-- Debug Feature - Dumps collider names, numbers, category bits, and masks
		--
		function collisionsCalculator:dump()
			print("*********************************************\n")
			print("Dumping collision settings...")
			print("name           | num | cat bits | col mask")
			print("-------------- | --- | -------- | --------")
			for colliderName, colliderNum in pairs(self._colliderNum) do
				print(colliderName:rpad(15,SPC) .. "| ".. 
		      		tostring(colliderNum):rpad(4,SPC) .. "| ".. 
			  		tostring(self._colliderCategoryBits[colliderName]):rpad(9,SPC) .. "| ".. 
			  		tostring(self._colliderMaskBits[colliderName]):rpad(8,SPC))
			end

			print("\n*********************************************\n")
		end

		return collisionsCalculator
	end

return collisionsCalculatorManger
