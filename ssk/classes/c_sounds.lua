-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Sound Manager
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

audio.setMinVolume( 0.0 )
audio.setMaxVolume( 1.0 )

soundMgr               = {}
soundMgr.soundsCatalog = {}
soundMgr.effectsVolume = 0.8
soundMgr.musicVolume   = 0.8

-- ============= addEffect()
function soundMgr:addEffect( name, file, stream, preload  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,false)
	entry.preload  = fnn(preload,false)
	entry.isEffect = true

	if(entry.preload) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end
end

-- ============= addMusic()
function soundMgr:addMusic( name, file, preload, fadein  )
	local entry = {}
	self.soundsCatalog[name] = entry

	entry.name     = name
	entry.file     = file
	entry.stream   = fnn(stream,false)
	entry.preload  = fnn(preload,false)
	entry.fadein   = fnn(fadein, 500 )
	entry.stream   = true
	entry.isEffect = false

	if(entry.preload) then
		entry.handle = audio.loadStream( entry.file )
	end
end

-- ============= setEffectsVolume()
function soundMgr:setEffectsVolume( value )
	self.effectsVolume = fnn(value or 1.0)
	if(self.effectsVolume < 0) then self.effectsVolume = 0 end
	if(self.effectsVolume > 1) then self.effectsVolume = 1 end
	return self.effectsVolume
end

-- ============= getEffectsVolume()
function soundMgr:getEffectsVolume( value )
	return self.effectsVolume
end

-- ============= setMusicVolume()
function soundMgr:setMusicVolume( value )
	self.musicVolume = fnn(value or 1.0)
	if(self.musicVolume < 0) then self.musicVolume = 0 end
	if(self.musicVolume > 1) then self.musicVolume = 1 end
	return self.musicVolume
end

-- ============= getMusicVolume()
function soundMgr:getMusicVolume( value )
	return self.musicVolume
end

-- ============= getMusicVolume()
function soundMgr:play( name )
	local entry = self.soundsCatalog[name]

	if(not entry) then
		print("Sound Manager - ERROR: Unknown sound: " .. name )
		return false
	end

	if(not entry.handle) then
		if(entry.stream) then
			entry.handle = audio.loadStream( entry.file )
		else
			entry.handle = audio.loadSound( entry.file )
		end
	end

	if(not entry.handle) then
		print("Sound Manager - ERROR: Failed to load sound: " .. name, entry.file )
		return false
	end

	local tmpChannel = audio.findFreeChannel()

	if(not tmpChannel == 0) then
		print("Sound Manager - ERROR: Failed to find free channel: " .. name )
		return false
	end

	if(entry.isEffect) then
		audio.setVolume( soundMgr.effectsVolume, {channel = tmpChannel} )
		audio.play( entry.handle, {channel = tmpChannel} )
	else
		audio.setVolume( soundMgr.musicVolume, {channel = tmpChannel} )
		audio.play( entry.handle, {channel = tmpChannel, loops = -1, fadein=entry.fadein} )
	end

	return true

end



return soundMgr