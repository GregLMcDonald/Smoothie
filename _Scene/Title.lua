local composer = require( "composer" )
local scene = composer.newScene()

local sound = require '_Assets.Sound'

function scene:create( event )
	local sceneGroup = self.view

	local bleed = display.newRect( 160, 240, 1.25 * 320 , 1.25 * 480 )
	bleed:setFillColor( 1 )
	sceneGroup:insert( bleed )

	

	local widthToCover = 500
	local heightToCover = 900
	local tileWidth = 180
	local tileHeight = 160

	local columns = math.ceil( widthToCover / tileWidth )
	local rows = math.ceil( heightToCover / tileHeight )
	local nTiles = columns * rows

	local tiledRegionWidth = columns * tileWidth
	local tiledRegionHeight = rows * tileHeight

	local startX = 160 - 0.5 * tiledRegionWidth
	local startY = 240 - 0.5 * tiledRegionHeight

	for i = 1, nTiles do
		local tile = display.newImageRect( '__image/title/foodAtomsLighter.jpg', tileWidth, tileHeight )
		tile.alpha = 0.5
		tile.anchorX = 0
		tile.anchorY = 1

		local myRow = 1 + math.floor( (i-1) / columns ) 
		local myColumn = i % columns 
		if myColumn == 0 then myColumn = columns end
		

		tile.x = startX + ( myColumn - 1 ) * tileWidth
		tile.y = startY + ( myRow - 1 ) * tileHeight

		sceneGroup:insert( tile )

	end


	local aspect = 646 / 414

	local title = display.newGroup()

	local titleImage = display.newImageRect( '__image/title/title.png', 300, 300/aspect )
	title:insert( titleImage )
	sceneGroup:insert( title )
	title.x = 160
	title.y = 50 + 0.5 * title.height


	local sheetInfo = require('__image.title.glint')
	local myImageSheet = graphics.newImageSheet( "__image/title/glint.png", sheetInfo:getSheet() )
	local sequenceData = {
		name = 'glinting',
		start = 1,
		count = 10,
		time = 400,
		loopCount = 1,
		loopDirection = 'bounce',
	}

	--[[

	Glint locations on title image at 646 x 414

	130,122
	501,150
	579,272


	]]


	local function getPositionOfGlint( xInGimp, yInGimp )
		local x
		local y

		local xFrac = xInGimp / 646
		local yFrac = yInGimp / 414

		x = -0.5 * titleImage.contentWidth + xFrac * titleImage.contentWidth
		y = -0.5 * titleImage.contentHeight + yFrac * titleImage.contentHeight

		return x,y

	end


	local glint1 = display.newSprite( myImageSheet , sequenceData )
	glint1.xScale = 0.5
	glint1.yScale = 0.5
	glint1.rotation = 45
	glint1.x, glint1.y = getPositionOfGlint( 130, 122)
	title:insert( glint1 )

	local glint2 = display.newSprite( myImageSheet , sequenceData ) 
	glint2.xScale = 0.5
	glint2.yScale = 0.5
	glint2.x, glint2.y = getPositionOfGlint( 501, 150)
	title:insert( glint2 )

	local glint3 = display.newSprite( myImageSheet , sequenceData ) 
	glint3.xScale = 0.5
	glint3.yScale = 0.5
	glint3.rotation = 60
	glint3.x, glint3.y = getPositionOfGlint( 579, 272)
	title:insert( glint3 )

	self.title = title
	function title:setAnimateGlints( state )
		if state == true then

			local function fireGlint1()
				glint1:play()
				local delayToNextGlintEvent = 2000 + 5000 * math.random()
				self.glint1Timer = timer.performWithDelay( delayToNextGlintEvent, fireGlint1 )
			end

			local function fireGlint2()
				glint2:play()
				local delayToNextGlintEvent = 2000 + 5000 * math.random()
				self.glint2Timer = timer.performWithDelay( delayToNextGlintEvent, fireGlint2 )
			end

			local function fireGlint3()
				glint3:play()
				local delayToNextGlintEvent = 2000 + 5000 * math.random()
				self.glint3Timer = timer.performWithDelay( delayToNextGlintEvent, fireGlint3 )
			end

			timer.performWithDelay( 2000 * math.random(), fireGlint1 )
			timer.performWithDelay( 2000 * math.random(), fireGlint2 )
			timer.performWithDelay( 2000 * math.random(), fireGlint3 )
			

		else
			if self.glint1Timer then
				timer.cancel( title.glint1Timer )
			end
			if self.glint2Timer then
				timer.cancel( title.glint2Timer )
			end
			if self.glint3Timer then
				timer.cancel( title.glint3Timer )
			end
		end

	end






	local lang = require( '_Assets.Language' ).getPreference()
	local playButtonFilename = '__image/title/playButton_en.png'
	if lang == 'lang_fr' then
		playButtonFilename = '__image/title/playButton_fr.png'
	end

	local playButtonAspect = 501/301
	local playButton = display.newGroup()
	local playButtonBase = display.newImageRect( playButtonFilename, 120, 120/playButtonAspect )
	playButton:insert(playButtonBase)
	local playButtonMarquee = display.newImageRect( '__image/title/playButtonMarquee.png', 120, 120/playButtonAspect )
	playButton:insert(playButtonMarquee )
	playButton.marquee = playButtonMarquee

	function playButton:setAnimated( state )
		if true == state then
			local function switchMarquee()
				if self.marquee.alpha == 1 then
					self.marquee.alpha = 0
				else
					self.marquee.alpha = 1
				end
			end
			self.animationTimer = timer.performWithDelay( 350, switchMarquee, -1 )
		else
			if self.animationTimer then
				timer.cancel( self.animationTimer )
			end
			self.marquee.alpha = 0
		end
	end
	playButton.x =  160
	playButton.y = title.y + 0.5 * title.height + 25 + 0.5 * playButton.height
	sceneGroup:insert(playButton)
	self.playButton = playButton

	function playButton:tap()
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Alert_03'} )
		composer.gotoScene( '_Scene.Play', { effect = 'crossFade', time = 300 } )
	end
	playButton:addEventListener( 'tap', playButton )

	--local goojajiAspect = 374/51
	--local studioGoojaji = display.newImageRect( '__image/title/goojaji.png', 150 , 250/goojajiAspect )
	--studioGoojaji.x = 160
	--studioGoojaji.y = 430
	--sceneGroup:insert(studioGoojaji)

	local isCurrentlyMuted = false
	if 0 == audio.getVolume() then isCurrentlyMuted = true end

	local muteButton = require( '_UI.MuteButton' ).new()
	muteButton.x = 25
	muteButton.y = 455
	sceneGroup:insert(muteButton)
	self.muteButton = muteButton
	muteButton:setMuted( isCurrentlyMuted, 0  )

	function muteButton:tap()
		muteButton:setMuted( not muteButton.isMuted )
	end
	muteButton:addEventListener( 'tap', muteButton )


	local infoButton = display.newImageRect( '__image/ui/info.png', 40, 40 )
	infoButton.x = 295
	infoButton.y = 455
	sceneGroup:insert( infoButton )
	function infoButton:tap()
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04' })
		composer.gotoScene( '_Scene.InfoView', { effect = 'crossFade', time = 250, params = { infoTextKey = 'credits'} } )
	end
	infoButton:addEventListener( 'tap', infoButton )


	local parentsButton = display.newGroup( )
	local parentsLabel = display.newText( {
		text = require( '_Assets.Text' ).forKey( 'parents' ),
		font = 'HAMBH___.ttf',
		fontSize = 30,
		})
	parentsLabel:setFillColor( 49/255, 242/255, 201/255  )
	
	local parentsBG = display.newRoundedRect( 0,0, parentsLabel.contentWidth + 20, 40, 5 )
	parentsBG:setFillColor( 37/255, 166/255, 138/255 )
	parentsButton:insert( parentsBG )
	parentsButton:insert( parentsLabel )
	parentsButton.x = infoButton.x - 25 - 0.5 * parentsBG.contentWidth
	parentsButton.y = infoButton.y
	sceneGroup:insert( parentsButton )
	function parentsButton:tap()
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04' })
		composer.gotoScene( '_Scene.InfoView', { effect = 'crossFade', time = 250, params = { infoTextKey = 'parentsGuide' } } )
	end
	parentsButton:addEventListener( 'tap', parentsButton )



end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    	composer.removeScene( '_Scene.InfoView' )

    	if self.muteButton then
            if 0 == audio.getVolume() then
                self.muteButton:setMuted( true, 0)   
            else
                self.muteButton:setMuted( false, 0 )
            end
        end

        if self.playButton then
        	self.playButton:setAnimated( true )
        end

        if self.title then
        	self.title:setAnimateGlints( true )
        end
        
        timer.performWithDelay( 100, function() sound.playBackgroundMusic(); sound.duckBackgroundMusic( false ) end )

    end
end
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    	sound.duckBackgroundMusic( true )


    elseif ( phase == "did" ) then

    	if self.playButton then
    		self.playButton:setAnimated( false )
    	end

    	if self.title then
        	self.title:setAnimateGlints( false )
        end

    	
    end
end
function scene:destroy( event )

    local sceneGroup = self.view
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene