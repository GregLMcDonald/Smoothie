
-- Credits.lua

local composer = require( "composer" )
local scene = composer.newScene()

local function goBack()
	Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04' })
	local previousSceneName = composer.getSceneName( 'previous' )
	composer.gotoScene( previousSceneName, { effect = 'crossFade', time = 250 } )
end

function scene:create( event )

	local infoTextKey = event.params.infoTextKey

	local sceneGroup = self.view


	local bleed = display.newRect( 160, 240, 1.25 * 320 , 1.25 * 480 )
	bleed:setFillColor( 1 )
	sceneGroup:insert( bleed )
	self.bleed = bleed

	

	local widthToCover = 500
	local heightToCover = 900
	local tileWidth = 180
	local tileHeight = 160

	local columns = math.ceil( widthToCover / tileWidth )
	local rows = math.ceil( heightToCover / tileHeight )
	local nTiles = columns * rows
	print('nTiles',nTiles)

	local tiledRegionWidth = columns * tileWidth
	local tiledRegionHeight = rows * tileHeight

	local startX = 160 - 0.5 * tiledRegionWidth
	local startY = 240 - 0.5 * tiledRegionHeight

	self.tileObjects = {}

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
		self.tileObjects[ #self.tileObjects + 1 ] = tile

	end


	local infoText = require( '_Assets.Text' ).forKey( infoTextKey )

	local textParameters = require '_Assets.TextParameters'
	local infoTextObject = display.newText({
		text = infoText,
		fontSize = textParameters.fontSize() ,
		font = 'Equity-Text-A-Regular.ttf',	
		width = textParameters.maximumLineLength(),
	} )

	infoTextObject:setFillColor( 43/255, 31/255, 25/255 )
	--infoTextObject:setFillColor( .5 )
	
	local scrollViewWidth = textParameters.maximumLineLength() + 10
	infoTextObject.x = 0.5 * scrollViewWidth
	infoTextObject.y = 0.5 * infoTextObject.contentHeight

	local widget = require 'widget'

	local scrollView = widget.newScrollView( {
		hideBackground = true,
		--backgroundColor = {.8,1,.8},
		--backgroundColor = {1,1,1},
		hideScrollBar = true,
		horizontalScrollDisabled = true,
		width = scrollViewWidth,
		height = 440,
		} )
	scrollView:insert( infoTextObject )
	sceneGroup:insert( scrollView )
	--scrollView.x = 0.5 * (320 - scrollViewWidth)
	--scrollView.x = 0
	scrollView.x = 160
	scrollView.y = 260
	self.scrollView = scrollView




	local closeButton = display.newImageRect( '__image/ui/close.png', 40, 40 )
	sceneGroup:insert( closeButton )
	closeButton.x = 300
	closeButton.y = 20
	function closeButton:tap()
		goBack()
		return true
	end
	closeButton:addEventListener( 'tap', closeButton )
	self.closeButton = closeButton


end


function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
    	Runtime:addEventListener( 'key', self )
    end
end
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    	Runtime:removeEventListener( 'key', self )
    elseif ( phase == "did" ) then
    	
    end
end
function scene:destroy( event )

	print('scene:destroy in InfoView')
    local sceneGroup = self.view

    if self.closeButton then
    	self.closeButton:removeSelf( )
    	self.closeButton = nil
    end

    if self.scrollView then
    	self.scrollView:removeSelf( )
    	self.scrollView = nil
    end

    while sceneGroup.numChildren > 0 do
    	local obj = sceneGroup[ sceneGroup.numChildren ]
    	obj:removeSelf( )
    end

end


function scene:key(event)
    local handledTouch = false
    if ( event.keyName == "back" ) then
       local platformName = system.getInfo( "platformName" )
       if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
         
            if event.phase == "up" then

            		goBack()
                    handledTouch = true

            end
        end
    end
    return handledTouch
end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene