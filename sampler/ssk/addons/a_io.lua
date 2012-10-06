-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- io Add-ons
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

-- ======================================================================
-- io - File Exists Check
--
-- system.DocumentsDirectory should be used for files that need to persist between application sessions.
-- system.TemporaryDirectory is a temporary directory. Files written to this directory are not guaranteed to exist in subsequent application sessions. They may or may not exist.
-- system.ResourceDirectory is the directory where all application assets exist. Note: you should never create, modify, or add files to this directory (see Beware Security Violations).
-- ======================================================================
function io.exists( fileName, base )
	local fileName = fileName
	if( base ) then
		fileName = system.pathForFile( fileName, base )
	end
	local f=io.open(fileName,"r")
	if (f == nil) then 
		return false
	end
	io.close(f)
	return true 
end
