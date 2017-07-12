local composer = require( "composer" )
local scene = composer.newScene()

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
		local tile = display.newImageRect( 'image/title/foodAtomsLighter.jpg', tileWidth, tileHeight )
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

	local title = display.newImageRect( 'image/title/title.png', 300, 300/aspect )
	sceneGroup:insert( title )
	title.x = 160
	title.y = 50 + 0.5 * title.height


	local lang = require( 'Language' ).getPreference()
	local playButtonFilename = 'image/title/playButton_en.png'
	if lang == 'lang_fr' then
		playButtonFilename = 'image/title/playButton_fr.png'
	end

	local playButtonAspect = 501/301
	local playButton = display.newImageRect( playButtonFilename, 120, 120/playButtonAspect )
	playButton.x =  160
	playButton.y = title.y + 0.5 * title.height + 25 + 0.5 * playButton.height
	sceneGroup:insert(playButton)

	function playButton:tap()
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Alert_03'} )
		composer.gotoScene( 'scene_Play', { effect = 'crossFade', time = 300 } )
	end
	playButton:addEventListener( 'tap', playButton )

	--local goojajiAspect = 374/51
	--local studioGoojaji = display.newImageRect( 'image/title/goojaji.png', 150 , 250/goojajiAspect )
	--studioGoojaji.x = 160
	--studioGoojaji.y = 430
	--sceneGroup:insert(studioGoojaji)

	local isCurrentlyMuted = false
	if 0 == audio.getVolume() then isCurrentlyMuted = true end

	local muteButton = require( 'UI.MuteButton' ).new()
	muteButton.x = 25
	muteButton.y = 455
	sceneGroup:insert(muteButton)
	self.muteButton = muteButton
	muteButton:setMuted( isCurrentlyMuted, 0  )

	function muteButton:tap()
		muteButton:setMuted( not muteButton.isMuted )
	end
	muteButton:addEventListener( 'tap', muteButton )


	local infoButton = display.newImageRect( 'image/ui/info.png', 40, 40 )
	infoButton.x = 295
	infoButton.y = 455
	sceneGroup:insert( infoButton )
	function infoButton:tap()
		composer.gotoScene( 'Scene.Credits' )
	end
	infoButton:addEventListener( 'tap', infoButton )


end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    	if self.muteButton then
            if 0 == audio.getVolume() then
                self.muteButton:setMuted( true, 0)   
            else
                self.muteButton:setMuted( false, 0 )
            end
        end

    end
end
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    	
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