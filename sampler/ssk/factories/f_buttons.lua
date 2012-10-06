-- =============================================================
-- Copyright Roaming Gamer, LLC.
-- =============================================================
-- Buttons Factory
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

-- EFM bug - slider chained cb not called if finger off knob during release
-- EFM add 'auto-fit' text option so long text is scaled/shrunk to fit

--[[ 
    Button Parms:

	unselRectEn
	selRectEn
	unselRectFillColor
	selRectFillColor
	-- OR (following overrides prior)	
	unselRectGradient
	selRectGradient 

	strokeWidth 
	strokeColor
	unselStrokeWidth
	unselStrokeColor
	selStrokeWidth
	selStrokeColor

	unselImgSrc 
	selImgSrc 
	unselImgFillColor
	selImgFillColor

	buttonOverlayImgSrc

	buttonOverlayRectColor

	onPress
	onRelease
	onEvent
	buttonType - "push"
	text - ""
	fontSize - 20
	textColor - {255,255,255,255}
	textFont - native.systemFontBold
	textOffset - {0,0}
	isPressed - false
	isEnabled - true
	pressSound
	releaseSound
	sound
    emboss - false


	Button Class Methods:
	buttonClass:addPreset( presetName, params )		
	buttonClass:new( params, screenGroup )
	buttonClass:presetPush( screenGroup, presetName, x,y,w,h, text,onRelease)
	buttonClass:presetToggle( screenGroup, presetName, x,y,w,h, text,onEvent)
	buttonClass:presetRadio( screenGroup, presetName, x,y,w,h, text,onRelease)
	
	buttonClass:quickHorizSlider( x,y,w,h,imageBase,text,fontSize,blackText,onEvent,onRelease,knobImg, kw,kh, screenGroup)
	buttonClass:touch( params )

	Button Instance Methods:
	buttonInstance:pressed( ) 
	buttonInstance:toggle( ) 
	buttonInstance:disable( ) 
	buttonInstance:enable( ) 
	buttonInstance:isEnabled() 
	buttonInstance:getText( ) 
	buttonInstance:setText( text ) 
	buttonInstance:adjustTextOffset( offset ) 
	buttonInstance:setFillColor( r,g,b,a ) 
	buttonInstance:setHighlight( vis )	

	Slider Instance Methods:
		tmpButton:getValue()
		tmpButton:setValue( val )
		tmpButton:disable( )
		tmpButton:enable( ) 


	Helper Functions:
	getCurrentRadio( group ) -- Helper function for radio button groups, gets current radio button


--]]

--
-- Helper Functions
--
function getCurrentRadio( group ) -- Helper function for radio button groups, gets current radio button
	return group.currentRadio
end

--[[
--
-- Button Class (Push, Toggle, Radio, Slider)
--
	Helper Functions:
	-- getCurrentRadio( group ) -- Helper function for radio button groups, gets current radio button		
   
	Class Methods:

	-- new( params )   - Create new button using specified params
	-- touch( params ) - The 'touch' handler for all three button types

	Instance Methods:

    -- toggle( )              - Toggle the state of a button (does NOT execute callbacks)
	-- pressed( )                 - Is the button pressed? (For toggle and radio buttons)
	-- getText( )                   - Get the current text value for button
	-- setText( text )              - Change button text
	-- adjustTextOffset( [offset] ) - Set offset of text (defaults to {0,0})

--]]

buttonClass = {}
buttonClass.presetsCatalog = {}

-- ============= addPreset()
function buttonClass:addPreset( presetName, params )
	local entry = {}
	self.presetsCatalog[presetName] = entry

	entry.unselRectEn     = fnn(params.unselRectEn, not params.unselImgSrc)
	entry.selRectEn       = fnn(params.selRectEn, not params.selImgSrc)

	entry.selRectFillColor     = params.selRectFillColor
	entry.unselRectFillColor   = params.unselRectFillColor

	entry.selRectGradient    = params.selRectGradient
	entry.unselRectGradient  = params.unselRectGradient

	-- set strokwidth and color globally 
	entry.strokeWidth    = params.strokeWidth
	entry.strokeColor    = params.strokeColor
    -- or individually
	entry.unselStrokeWidth  = params.unselStrokeWidth
	entry.unselStrokeColor  = params.unselStrokeColor
	entry.selStrokeWidth    = params.selStrokeWidth
	entry.selStrokeColor    = params.selStrokeColor


	entry.unselImgSrc     = params.unselImgSrc
	entry.selImgSrc       = params.selImgSrc

	entry.selImgFillColor     = params.selImgFillColor
	entry.unselImgFillColor   = params.unselImgFillColor

	entry.buttonOverlayRectColor  = params.buttonOverlayRectColor

	entry.buttonOverlayImgSrc  = params.buttonOverlayImgSrc

	entry.onPress      = params.onPress
	entry.onRelease    = params.onRelease
	entry.onEvent      = params.onEvent
	entry.buttonType   = fnn(params.buttonType, "push" )

	entry.text         = fnn(params.text, "")
	entry.fontSize     = fnn(params.fontSize, 20)
	entry.textColor    = fnn(params.textColor, {255,255,255,255})
	entry.textFont     = fnn(params.textFont, native.systemFontBold)
	entry.textOffset   = fnn(params.textOffset, {0,0})
	entry.isPressed    = fnn(params.isPressed, false)
	entry.isEnabled    = fnn(params.isEnabled, true)
	entry.pressSound   = params.pressSound
	entry.releaseSound = params.releaseSound
	entry.sound        = params.sound
    entry.emboss       = fnn(params.emboss, false)

end

-- ============= new()
function buttonClass:new( params, screenGroup )
	local buttonInstance = display.newGroup()

	-- 1. Check for catalog entry option and apply FIRST 
	-- (allows us to override by passing params too)
	buttonInstance.presetName = params.presetName
	local presetCatalogEntry  = self.presetsCatalog[buttonInstance.presetName]

	if(presetCatalogEntry) then
		for k,v in pairs(presetCatalogEntry) do
			buttonInstance[k] = v
		end
	end

	-- 2. Apply any passed params
	if(params) then
		for k,v in pairs(params) do
			buttonInstance[k] = v
		end
	end

	-- 3. Ensure all 'required' values have something in them or assign defaults
	buttonInstance.x            = fnn(buttonInstance.x, 0)
	buttonInstance.y            = fnn(buttonInstance.y, 0)
	buttonInstance.w            = fnn(buttonInstance.w, 178)
	buttonInstance.h            = fnn(buttonInstance.h, 56)
	buttonInstance.buttonType   = fnn(buttonInstance.buttonType, "push")

	buttonInstance.text         = fnn(buttonInstance.text, "")
	buttonInstance.fontSize     = fnn(buttonInstance.fontSize, 20)
	buttonInstance.textColor    = fnn(buttonInstance.textColor, {255,255,255,255})
	buttonInstance.textFont     = fnn(buttonInstance.textFont, native.systemFontBold)
	buttonInstance.textOffset   = fnn(buttonInstance.textOffset, {0,0})
    buttonInstance.emboss       = fnn(buttonInstance.emboss, false)

	buttonInstance.isPressed    = false -- start off unpressed

	-- ====================
	-- Create the button
	-- ====================

	-- UNSEL RECT
	if(buttonInstance.unselRectEn) then
		local unselRect
		unselRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.strokeWidth) then
			unselRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			unselRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.unselRectFillColor ) then
			local r = fnn(buttonInstance.unselRectFillColor[1], 255)
			local g = fnn(buttonInstance.unselRectFillColor[2], 255)
			local b = fnn(buttonInstance.unselRectFillColor[3], 255)
			local a = fnn(buttonInstance.unselRectFillColor[4], 255)
			unselRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.unselRectGradient) then
			unselRect:setFillColor( buttonInstance.unselRectGradient )
		end

		if(buttonInstance.unselStrokeColor) then
			local r = fnn(buttonInstance.unselStrokeColor[1], 255)
			local g = fnn(buttonInstance.unselStrokeColor[2], 255)
			local b = fnn(buttonInstance.unselStrokeColor[3], 255)
			local a = fnn(buttonInstance.unselStrokeColor[4], 255)
			unselRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 255)
			local g = fnn(buttonInstance.strokeColor[2], 255)
			local b = fnn(buttonInstance.strokeColor[3], 255)
			local a = fnn(buttonInstance.strokeColor[4], 255)
			unselRect:setStrokeColor(r,g,b,a)
		end

		buttonInstance:insert( unselRect, true )
		unselRect.isVisible = true
		buttonInstance.unselRect = unselRect
		
	end

	-- SEL RECT
if(buttonInstance.selRectEn) then

		local selRect
		selRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.strokeWidth) then
			selRect.strokeWidth = buttonInstance.strokeWidth
		elseif(buttonInstance.selStrokeWidth) then
			selRect.strokeWidth = buttonInstance.selStrokeWidth
		end

		if(buttonInstance.selRectFillColor ) then
			local r = fnn(buttonInstance.selRectFillColor[1], 255)
			local g = fnn(buttonInstance.selRectFillColor[2], 255)
			local b = fnn(buttonInstance.selRectFillColor[3], 255)
			local a = fnn(buttonInstance.selRectFillColor[4], 255)
			selRect:setFillColor(r,g,b,a)
		end

		if(buttonInstance.selRectGradient) then
			selRect:setFillColor( buttonInstance.selRectGradient )
		end

		if(buttonInstance.selStrokeColor) then
			local r = fnn(buttonInstance.selStrokeColor[1], 255)
			local g = fnn(buttonInstance.selStrokeColor[2], 255)
			local b = fnn(buttonInstance.selStrokeColor[3], 255)
			local a = fnn(buttonInstance.selStrokeColor[4], 255)
			selRect:setStrokeColor(r,g,b,a)

		elseif(buttonInstance.strokeColor) then
			local r = fnn(buttonInstance.strokeColor[1], 255)
			local g = fnn(buttonInstance.strokeColor[2], 255)
			local b = fnn(buttonInstance.strokeColor[3], 255)
			local a = fnn(buttonInstance.strokeColor[4], 255)
			selRect:setStrokeColor(r,g,b,a)
		end
	
		buttonInstance:insert( selRect, true )
		selRect.isVisible = false
		buttonInstance.selRect = selRect
	end

	-- UNSEL IMG
	if(buttonInstance.unselImgSrc) then		
		local unselImgObj
		unselImgObj = display.newImageRect( buttonInstance.unselImgSrc, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.unselImgFillColor ) then
			local r = fnn(buttonInstance.unselImgFillColor[1], 255)
			local g = fnn(buttonInstance.unselImgFillColor[2], 255)
			local b = fnn(buttonInstance.unselImgFillColor[3], 255)
			local a = fnn(buttonInstance.unselImgFillColor[4], 255)
			unselImgObj:setFillColor(r,g,b,a)
		end

		buttonInstance:insert( unselImgObj, true )
		unselImgObj.isVisible = true
		buttonInstance.unsel = unselImgObj
	end
	
	-- SEL IMG
	if(buttonInstance.selImgSrc) then		
		local selImgObj
		selImgObj = display.newImageRect( buttonInstance.selImgSrc, buttonInstance.w, buttonInstance.h)

		if(buttonInstance.selImgFillColor ) then
			local r = fnn(buttonInstance.selImgFillColor[1], 255)
			local g = fnn(buttonInstance.selImgFillColor[2], 255)
			local b = fnn(buttonInstance.selImgFillColor[3], 255)
			local a = fnn(buttonInstance.selImgFillColor[4], 255)
			selImgObj:setFillColor(r,g,b,a)
		end

		buttonInstance:insert( selImgObj, true )
		selImgObj.isVisible = false
		buttonInstance.sel = selImgObj
	end
		
	-- BUTTON Overlay Rect
	if(buttonInstance.buttonOverlayRectColor) then
		local r = fnn(buttonInstance.buttonOverlayRectColor[1], 255)
		local g = fnn(buttonInstance.buttonOverlayRectColor[2], 255)
		local b = fnn(buttonInstance.buttonOverlayRectColor[3], 255)
		local a = fnn(buttonInstance.buttonOverlayRectColor[4], 255)
		local overlayRect = display.newRect( buttonInstance.w/2, buttonInstance.h/2, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayRect, true )
		buttonInstance.overlayRect = overlayRect
		buttonInstance.overlayRect:setFillColor( r,g,b,a )
	end

	-- BUTTON Overlay Image
	if(buttonInstance.buttonOverlayImgSrc) then
		local overlayImage = display.newImageRect( buttonInstance.buttonOverlayImgSrc, buttonInstance.w, buttonInstance.h)
		buttonInstance:insert( overlayImage, false )
		buttonInstance.overlayImage = overlayImage
	end

	-- BUTTON TEXT
	local labelText 
	if(buttonInstance.emboss) then
		labelText = display.newEmbossedText( buttonInstance.text, 0, 0, buttonInstance.textFont, buttonInstance.fontSize, buttonInstance.textColor )
	else
		labelText = display.newText( buttonInstance.text, 0, 0, buttonInstance.textFont, buttonInstance.fontSize )
	end	

	buttonInstance.labelText = labelText
	labelText:setTextColor( buttonInstance.textColor[1], buttonInstance.textColor[2], 
	                        buttonInstance.textColor[3], buttonInstance.textColor[4] )
	labelText:setReferencePoint( display.CenterReferencePoint )
	buttonInstance:insert( labelText, true )
	labelText.x = buttonInstance.textOffset[1]
	labelText.y = buttonInstance.textOffset[2]

	buttonInstance:addEventListener( "touch", self )

	-- ============= pressed() -- Return true if pressed
	function buttonInstance:pressed( ) 
		return self.isPressed
	end

	-- ============= toggle() -- Toggle the state of a button (executes callbacks)
	function buttonInstance:toggle( ) 
		--for k,v in pairs(self) do print(k,v) end

		local buttonEvent = {}
		buttonEvent.target = self
		buttonEvent.id = self.id
		buttonEvent.x = self.x
		buttonEvent.y = self.y
		buttonEvent.name = "touch"
		buttonEvent.phase = "began"
		buttonEvent.forceInBounds = true
		self:dispatchEvent( buttonEvent )
		buttonEvent.phase = "ended"
		self:dispatchEvent( buttonEvent )
	end

	-- ============= disable() -- Disable button and reduce alpha as visual feedback
	function buttonInstance:disable( ) 
		self.isEnabled = false
		self.labelText.alpha = 0.3			
		self.sel.alpha = 0.3
		self.unsel.alpha = 0.3
	end

	-- ============= enable() -- Enable button and increase alpha as visual feedback
	function buttonInstance:enable( ) 
		self.isEnabled = true
		self.labelText.alpha = 1.0
		self.sel.alpha = 1.0
		self.unsel.alpha = 1.0
	end

	-- ============= isEnabled() -- Return true if button is enabled
	function buttonInstance:isEnabled() 
		return (self.isEnabled == true)
	end

	-- ============= getText() -- Return current text displayed on button
	function buttonInstance:getText( ) 
		--print( "buttonInstance:getText() self.text == " .. tostring(self.text) )
		return tostring(self.text)
	end

	-- ============= setText() -- Set current text displayed on button
	function buttonInstance:setText( text ) 
		local labelText = self.labelText
		if(self.emboss) then
			labelText:setText( text )
		else
			labelText.text = text
		end

		self.text = text

		--print( "buttonInstance:setText() self.text == " .. tostring(self.text) )
		
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x = self.textOffset[1]
		labelText.y = self.textOffset[2]
	end

	-- ============= adjustTextOffset() -- Move button text by specified x,y
	function buttonInstance:adjustTextOffset( offset ) 
		local offset = fnn(offset, {0,0})
		local labelText = self.labelText
		self.textOffset = offset
		labelText:setReferencePoint( display.CenterReferencePoint )
		labelText.x = self.textOffset[1]
		labelText.y = self.textOffset[2]
	end

	-- ============= setFillColor() -- Set button images fill color
	function buttonInstance:setFillColor( r,g,b,a ) 
		local r = fnn(r, 255)
		local g = fnn(g, 255)
		local b = fnn(b, 255)
		local a = fnn(a, 255)
		self.sel:setFillColor(r,g,b,a)
		self.unsel:setFillColor(r,g,b,a)
	end

	-- ============= setHighlight() -- Set button images fill color
	function buttonInstance:setHighlight( vis )	
		--if(not self.selRect) then print "NO RECT" end	
		--if(not self.sel) then print "NO IMAGE" end	
		--if(not self.overlayRect) then print "NO OVERLAY RECT" end	
		--if(not self.overlayImage) then print "NO OVERLAY IMAGE" end	

		if(self.selRect) then self.selRect.isVisible = vis end
		if(self.unselRect) then self.unselRect.isVisible = (not vis) end
		if(self.sel) then self.sel.isVisible = vis end
		if(self.unsel) then self.unsel.isVisible = (not vis) end
	end


	screenGroup:insert( buttonInstance )

	return buttonInstance
end


-- ============= presetPush() -- Quick push button creator
function buttonClass:presetPush( screenGroup, presetName, x,y,w,h, text,onRelease, overrideParams)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "push",
		text = text,
		onRelease = onRelease,
	}

	if(overrideParams) then
		for k,v in pairs(overrideParams) do
			tmpParams[k] = v
		end
	end


	local tmpButton = self:new( tmpParams, screenGroup )

	return tmpButton
end


-- ============= presetToggle() -- Quick toggle button creator
function buttonClass:presetToggle( screenGroup, presetName, x,y,w,h, text,onEvent)
	local presetName = presetName or "default"

	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "toggle",
		text = text,
		onEvent = onEvent,
	}
	local tmpButton = self:new( tmpParams, screenGroup )

	return tmpButton
end


-- ============= presetRadio() -- Quick radio button creator
function buttonClass:presetRadio( screenGroup, presetName, x,y,w,h, text,onRelease)
	local presetName = presetName or "default"
	
	--print("PUSH BUTTON w = " .. w .. " h = " .. h)
	local tmpParams = 
	{ 
		presetName = presetName,
		w = w,
		h = h,
		x = x,
		y = y,
		buttonType = "radio",
		text = text,
		onRelease = onRelease,
	}
	local tmpButton = self:new( tmpParams, screenGroup )
	return tmpButton
end


-- ============= quickHorizSlider() -- Quick slider creator
function buttonClass:quickHorizSlider( x,y,w,h,imageBase,onEvent,onRelease,knobImg, kw,kh, screenGroup)
	local tmpParams = 
	{ 
		w = w,
		h = h,
		x = x,
		y = y,
		unselImgSrc = imagesDir .. imageBase .. ".png",
		selImgSrc   = imagesDir .. imageBase .. "Over.png",
		buttonType = "push",
		pressSound = buttonSound,
		onEvent = onEvent,
		onRelease = onRelease,
		emboss = true,
	}
	local tmpButton = self:new( tmpParams, screenGroup )

	local sliderKnob = display.newImageRect(knobImg, kw, kh )
	sliderKnob.x = tmpButton.x - tmpButton.width/2  + tmpButton.width/2
	sliderKnob.y = tmpButton.y
	tmpButton.myKnob = sliderKnob
	tmpButton.value = 0

	screenGroup:insert(sliderKnob)

	function tmpButton:getValue()
		return  tonumber(string.format("%1.2f", self.value))
	end

	function tmpButton:setValue( val )
		local knob = self.myKnob
		local left = (self.x - self.width/2) + knob.width/2
		local right = (self.x + self.width/2)  - knob.width/2
		local width = right-left

		if(val < 0) then
			self.value = 0
		elseif( val > 1 ) then
			self.value = 1
		else
			self.value = tonumber(string.format("%1.2f", val))
		end

		knob.x = left + (width * self.value)
	end

	-- ============= disable() -- Disable button and reduce alpha as visual feedback
	function tmpButton:disable( ) 
		self.isEnabled = false
		self.sel.alpha = 0.3
		self.unsel.alpha = 0.3
		self.myKnob.alpha = 0.3
	end

	-- ============= enable() -- Enable button and increase alpha as visual feedback
	function tmpButton:enable( ) 
		self.isEnabled = true
		self.sel.alpha = 1.0
		self.unsel.alpha = 1.0
		self.myKnob.alpha = 1.0		
	end

	return tmpButton, sliderKnob
end



-- ============= touch() -- Touch handler for all button types
function buttonClass:touch( params )
	--for k,v in pairs(params) do print(k,v) end
	local result         = true
	local theButton      = params.target 
	local phase          = params.phase
	local sel            = theButton.sel
	local unsel          = theButton.unsel
	local onPress        = theButton.onPress
	local onRelease      = theButton.onRelease
	local onEvent        = theButton.onEvent
	local buttonType     = theButton.buttonType
	local parent         = theButton.parent
	local sound          = theButton.sound
	local pressSound     = theButton.pressSound
	local releaseSound   = theButton.releaseSound
	local forceInBounds  = params.forceInBounds


	-- If not enabled, exit immediately
	if(theButton.isEnabled == false) then
		return result
	end

	local buttonEvent = params -- For passing to callbacks

	if(phase == "began") then
		theButton:setHighlight(true)
		display.getCurrentStage():setFocus( theButton )
		theButton.isFocus = true

		-- Only Pushbutton fires event here
		if(buttonType == "push") then
			-- PUSH BUTTON
			--print("push button began")
			theButton.isPressed = true
			if( sound ) then audio.play( sound ) end
			if( pressSound ) then audio.play( pressSound ) end
			if( onPress ) then result = result and onPress( buttonEvent ) end
			if( onEvent ) then result = result and onEvent( buttonEvent ) end
		end

	elseif theButton.isFocus then
		local bounds = theButton.stageBounds
		local x,y = params.x, params.y
		local isWithinBounds = 
			bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y

		if( forceInBounds == true ) then
			isWithinBounds = true
		end

		if( phase == "moved") then
			if(buttonType == "push") then
				theButton:setHighlight(isWithinBounds)
				--sel.isVisible   = isWithinBounds
				--unsel.isVisible = not isWithinBounds
				if( onEvent ) then result = result and onEvent( buttonEvent ) end
			elseif(buttonType == "toggle") then
				if( not isWithinBounds ) then
					theButton:setHighlight(theButton.isPressed)
					--sel.isVisible   = theButton.isPressed
					--unsel.isVisible = not theButton.isPressed					
				else
					theButton:setHighlight(true)
					--sel.isVisible   = true
					--unsel.isVisible = false
				end
			elseif(buttonType == "radio") then
			end

		elseif(phase == "ended" or phase == "cancelled") then
			--print("buttonType " .. buttonType )
			------------------------------------------------------
			if(buttonType == "push") then -- PUSH BUTTON
			------------------------------------------------------
				--print "push button ended"				
				theButton:setHighlight(false)
				--sel.isVisible   = false
				--unsel.isVisible = true

				theButton.isPressed = false

				if isWithinBounds then
					if( sound ) then audio.play( sound ) end
					if( releaseSound ) then audio.play( releaseSound ) end
					if( onRelease ) then result = result and onRelease( buttonEvent ) end
					if( onEvent ) then result = result and onEvent( buttonEvent ) end
				end
			
			------------------------------------------------------
			elseif(buttonType == "toggle") then -- TOGGLE BUTTON				
			------------------------------------------------------
				--print( "\ntoggle button ended -- " .. buttonEvent.phase )
				if isWithinBounds then
					if(theButton.isPressed == true) then
						theButton.isPressed = false
						if( sound ) then audio.play( sound ) end
						if( releaseSound ) then audio.play( releaseSound ) end
						if( onRelease ) then result = result and onRelease( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					else
						theButton.isPressed = true
						buttonEvent.phase = "began"
						if( sound ) then audio.play( sound ) end
						if( pressSound ) then audio.play( pressSound ) end
						if( onPress ) then result = result and onPress( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					end					
				end
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed				
			------------------------------------------------------
			elseif(buttonType == "radio") then -- RADIO BUTTON
			------------------------------------------------------
				--print "radio button ended" 
				if isWithinBounds then
					if( parent.currentRadio ~= theButton ) then
						local oldRadio = parent.currentRadio
						if( oldRadio ) then
							oldRadio.isPressed = false
							buttonEvent.theButton = oldRadio
							if( sound ) then audio.play( sound ) end
							if( releaseSound ) then audio.play( releaseSound ) end
							if( onRelease ) then result = result and onRelease( buttonEvent ) end
							if( onEvent ) then result = result and onEvent( buttonEvent ) end
							oldRadio:setHighlight(false)
							--oldRadio.sel.isVisible   = false
							--oldRadio.unsel.isVisible = true
						end
						
						parent.currentRadio = theButton
						buttonEvent.theButton = theButton

						theButton.isPressed = true
						buttonEvent.phase = "began"
						if( sound ) then audio.play( sound ) end
						if( pressSound ) then audio.play( pressSound ) end
						if( onPress ) then result = result and onPress( buttonEvent ) end
						if( onEvent ) then result = result and onEvent( buttonEvent ) end
					end
				end
				
				theButton:setHighlight(theButton.isPressed)
				--sel.isVisible   = theButton.isPressed
				--unsel.isVisible = not theButton.isPressed
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( nil )
			theButton.isFocus = false


		end
	end
	return result
end

return buttonClass