-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Labels Factory
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
    Label Parms:
	text - ""
	font - native.systemFontBold
	fontSize - 20
	textColor - {255,255,255,255}
	emboss - false
	embossTextColor - {255,255,255,255}
	embossHighlightColor - {255,255,255,255}
	embossShadowColor - {0,0,0,255}
	referencePoint - display.CenterReferencePoint

	Label Class Methods:
	labelClass:addPreset( presetName, params )
	labelClass:new( params, screenGroup )

	labelClass:presetLabel( group, presetName, text, x, y, params  )

	labelClass:quickLabel( group, text, x, y, font, fontSize, textColor )
	labelClass:quickEmbossedLabel( group, text, x, y, font, fontSize, embossTextColor, embossHighlightColor, embossShadowColor )

	Label Instance Methods:
	labelInstance:setText( text )
	labelInstance:getText()
	-- EFM missing function to change textColor of normal text?  probably not; use default library call setTextColor() ?
	labelInstance:setLabelTextColor( textColor ) -- embossed only
	labelInstance:setHighlightTextColor( textColor ) -- embossed only
	labelInstance:setShadowTextColor( textColor ) -- embossed only
	labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )-- embossed only 
--]]

-- External helper functions
labelClass = {}
labelClass.presetsCatalog = {}

-- ============= addPreset()
function labelClass:addPreset( presetName, params )
	local entry = {}

	self.presetsCatalog[presetName] = entry

	entry.text           = fnn(params.text, "")
	entry.font           = fnn(params.font, native.systemFontBold)
	entry.fontSize       = fnn(params.fontSize, 20)
	entry.textColor          = fnn(params.textColor, {255,255,255,255})

	entry.emboss         = fnn(params.emboss, false)
	entry.embossTextColor     = fnn(params.embossTextColor, {255,255,255,255})
	entry.embossHighlightColor = fnn(params.embossHighlightColor, {255,255,255,255})
	entry.embossShadowColor    = fnn(params.embossShadowColor, {0,0,0,255})

	entry.referencePoint = fnn(params.referencePoint, display.CenterReferencePoint)
end

-- ============= new()
function labelClass:new( params, screenGroup )

	local tmpParams = {}

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	tmpParams.presetName     = params.presetName, nil 
	local presetCatalogEntry = self.presetsCatalog[tmpParams.presetName]
	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			tmpParams[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			tmpParams[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them Snag Setting (assume all set)
	tmpParams.x              = fnn(tmpParams.x, display.contentWidth/2)
	tmpParams.y              = fnn(tmpParams.y, 0)
	tmpParams.embossTextColor     = fnn(tmpParams.embossTextColor, {255,255,255,255})
	tmpParams.embossHighlightColor = fnn(tmpParams.embossHighlightColor, {255,255,255,255})
	tmpParams.embossShadowColor    = fnn(tmpParams.embossShadowColor, {0,0,0,255})
	tmpParams.referencePoint = fnn(tmpParams.referencePoint, display.CenterReferencePoint)

	-- Create the label
	local labelInstance
	if(tmpParams.emboss) then
		labelInstance = display.newEmbossedText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize, tmpParams.textColor )
	else
		labelInstance = display.newText( tmpParams.text, 0, 0, tmpParams.font, tmpParams.fontSize )
	end	

	-- 4. Store the params directly in the 
	for k,v in pairs(tmpParams) do
		labelInstance[k] = v
	end

	-- 5. Assign methods based on embossed or not
	if(labelInstance.emboss) then

		function labelInstance:setText( text )
			self.label.text = text
			self.highlight.text = text
			self.shadow.text = text
			self.text = text
			return self.text
		end

		function labelInstance:setLabelTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.label:setTextColor(r,g,b,a)
		end

		function labelInstance:setHighlightTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.highlight:setTextColor(r,g,b,a)
		end

		function labelInstance:setShadowTextColor( textColor )
			local r = textColor[1] or 255
			local g = textColor[2] or 255
			local b = textColor[3] or 255
			local a = textColor[4] or 255
			self.shadow:setTextColor(r,g,b,a)
		end

		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			self:setLabelTextColor(embossTextColor)
			self:setHighlightTextColor(embossHighlightColor)
			self:setShadowTextColor(embossShadowColor)
		end

		function labelInstance:getText()
			return self.text
		end

	else

		function labelInstance:setText( text )
			self.text = text
			return self.text
		end

		function labelInstance:setLabelTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setHighlightTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setShadowTextColor( textColor )
			print("warning: not embossed text" )
		end

		function labelInstance:setTextColors( embossTextColor, embossHighlightColor, embossShadowColor )
			print("warning: not embossed text" )
		end

		function labelInstance:getText()
			return self.text
		end

	end	

	-- 6. Set textColor
	if(labelInstance.emboss) then
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end

		if(labelInstance.embossTextColor) then
			labelInstance:setLabelTextColor(labelInstance.embossTextColor)
		end
		if(labelInstance.embossHighlightColor) then
			labelInstance:setHighlightTextColor(labelInstance.embossHighlightColor)
		end
		if(labelInstance.embossShadowColor) then
			labelInstance:setShadowTextColor(labelInstance.embossShadowColor)
		end
	else
		if(labelInstance.textColor) then
			local r = fnn(labelInstance.textColor[1],  255)
			local g = fnn(labelInstance.textColor[2],  255)
			local b = fnn(labelInstance.textColor[3],  255)
			local a = fnn(labelInstance.textColor[4],  255)
			labelInstance:setTextColor(r,g,b,a)
		end
	end

	-- 6. Set reference point and do final positioning
	labelInstance:setReferencePoint( labelInstance.referencePoint )
	labelInstance.x = tmpParams.x
	labelInstance.y = tmpParams.y

	if(screenGroup) then
		screenGroup:insert(labelInstance)
	end

	return labelInstance
end


function labelClass:presetLabel( group, presetName, text, x, y, params  )
	local presetName = presetName or "default"
		
	local tmpParams = params or {}
	tmpParams.presetName = presetName
	tmpParams.text = text
	tmpParams.x = x
	tmpParams.y = y
	
	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end


function labelClass:quickLabel( group, text, x, y, font, fontSize, textColor )
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		textColor  = textColor or _WHITE_
	}

	local tmpLabel = self:new(tmpParams, group)
	return tmpLabel
end


function labelClass:quickEmbossedLabel( group, text, x, y, font, fontSize, embossTextColor, embossHighlightColor, embossShadowColor )
	local tmpParams = 
	{ 
		text = text,
		x = x,
		y = y,
		font = font or native.systemFont,
		fontSize = fontSize or 16,
		embossTextColor  = embossTextColor or _GREY_,
		embossHighlightColor  = embossHighlightColor or _WHITE_,
		embossShadowColor  = embossShadowColor or _BLACK_,
		emboss = true
	}

	local tmpLabel = self:new(tmpParams)
	group:insert(tmpLabel)
	return tmpLabel
end


return labelClass