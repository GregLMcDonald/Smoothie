-- overlay_Log.lua

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require 'widget'
local IngredientDisplayObject = require 'IngredientDisplayObject'
local textParameters = require 'TextParameters'

local bookColour = { 37/255, 185/255, 154/255 }

scene.isShowingComment = false
local function createCommentsDisplay( comments, startX, startY )

	local transitionTime = 150

	local result = display.newGroup()

	local maskTable = display.newRect( 0,0,320,480)
	maskTable:setFillColor( 1 )
	maskTable.alpha = 0
	result:insert( maskTable )
	result.maskTable = maskTable

	




	local textObject = display.newText( {
		text = comments,
		fontSize = textParameters.fontSize() ,
		font = 'Equity-Text-A-Regular.ttf',	
		width = textParameters.maximumLineLength(),
		} )
	textObject:setFillColor( 43/255, 31/255, 25/255 )
	local commentWidth = textParameters.maximumLineLength() + 20

	local closeButton = display.newImageRect( 'image/ui/close.png', 40, 40 )
	closeButton.x = 0.5 * commentWidth - 20

	result.closeButton = closeButton
	closeButton:addEventListener( 'tap', result )
	result:insert( closeButton )

	if textObject.contentHeight < 410 then

		local commentHeight = textObject.contentHeight + 20

		
		closeButton.y = - 0.5 * commentHeight - 24

		local bg = display.newRoundedRect( 0,0, commentWidth, textObject.contentHeight + 20 ,10)
		bg:setFillColor( 1 )
		bg:setStrokeColor( unpack( bookColour) )
		bg.strokeWidth = 3
		result:insert( bg )

		textObject.x = 0
		textObject.y = 0
		result:insert( textObject )

	else

		closeButton.y = - 240 + 22

		local bg = display.newRoundedRect( 0,0,commentWidth,430,10)
		bg:setFillColor( 1 )
		bg:setStrokeColor( unpack( bookColour) )
		bg.strokeWidth = 3
		bg.y = 22.5
		result:insert( bg )

		local widget = require 'widget'
		local scrollView = widget.newScrollView( {
			width = commentWidth - 10 ,
			height = 420,
			horizontalScrollDisabled = true,
			backgroundColor = {1,1,1},
			} )
		--scrollView.x = -150
		--scrollView.y = -230
		scrollView.x = 0
		scrollView.y = 22.5
		
		textObject.x = 0.5 * (commentWidth - 10)
		textObject.y = 0.5 * textObject.contentHeight
		scrollView:insert( textObject )
		result:insert( scrollView )

	end

	function result:tap()

		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04'} )

		local function onComplete()
			scene.isShowingComment = false
			result.closeButton:removeEventListener( 'tap', self )
			result:removeSelf( )
		end

		transition.to( self.maskTable, { alpha = 0, time = 50 })
		local x = startX or self.x
		local y = startY or self.y
		transition.to( self, { x = x, y = y, xScale = 0.01, yScale = 0.01, delay = 50, time = transitionTime, onComplete = onComplete })


	end
	

	result.x = startX
	result.y = startY

	result.xScale = 0.01
	result.yScale = 0.01


	transition.to( result, { x = 160, y = 240, xScale = 1, yScale = 1, time = transitionTime })
	
	transition.to( result.maskTable, { alpha = 0.95, delay = transitionTime + 20, time = 50 } ) 


	return result
end
local function createLogEntryDisplay( entry, rowNumber )
	
	local recipe = entry.recipe
	local rating = entry.rating
	local comments = entry.comments 

	local result = display.newGroup()

	local ingredientLineY = 7.5
	local ratingLineY = -23	

	local ratingObj = require( 'UI.RatingDisplay').new( rating )

	local ratingScale = 15 / ratingObj.height
	ratingObj.xScale = ratingScale
	ratingObj.yScale = ratingScale

	local ratingObjWidth = ratingObj.width * ratingScale


	ratingObj.x = 320 - ratingObjWidth - 2

	ratingObj.y = ratingLineY
	result:insert( ratingObj )



	local lastIngredientX = 0
	for i=1,#recipe.ingredients do
		local obj = IngredientDisplayObject.new( recipe.ingredients[ i ] )


		obj.xScale = 0.8
		obj.yScale = 0.8

		obj.x = 20 + (i-1)*40
		lastIngredientX = obj.x
		obj.y = ingredientLineY
		result:insert( obj )

	end

	if recipe.appliance.imageFilename then
		local applianceImage = display.newImageRect( recipe.appliance.imageFilename, 40, 40 )
		if applianceImage then
			applianceImage.x = lastIngredientX + 40
			applianceImage.y = ingredientLineY
			result:insert( applianceImage )
		end
	end


	local comment = display.newImageRect( 'image/ui/chatGreenFilled.png', 40, 40)
	comment.x = ratingObj.x + 0.5 * ratingObjWidth
	comment.y = ingredientLineY
	comment.rowNumber = rowNumber

	function comment:tap()


		if scene.isShowingComment == true then return true end

		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Maximise_08' } )

		local commentY = 32.5 + (self.rowNumber - 1) * 65 + 40 + scene.logTable:getContentPosition()
		local commentX = self.x


		local commentObj = createCommentsDisplay( comments, commentX, commentY )
	

		scene.view:insert(commentObj)
		scene.isShowingComment = true

	end
	comment:addEventListener( 'tap', comment )
	result:insert( comment )




	return result
end




function scene:create( event )

	local log = event.params.log

	local sceneGroup = self.view

	local logPage = display.newGroup( )
	self.logPage = logPage
	
	sceneGroup:insert( logPage)

	local bleed = display.newRect( 0, 0, 1.25 * display.contentWidth, 1.25 * display.contentHeight )
	bleed:setFillColor( unpack( bookColour ) )
	bleed.x = 0
	bleed.y = 0
	logPage:insert( bleed )

	local bg = display.newRect( 0, 0, 320, 480)
	bg:setFillColor( 1 )
	bg.x = 0
	bg.y = 0
	logPage:insert( bg )


	--local close = display.newImageRect( 'image/ui/arrows.png', 30, 30 )
	--close.x = -143

	local close = display.newImageRect( 'image/ui/kitchen.png', 30, 30 )
	close.x = 143
	
	close.y = -220
	logPage:insert( close )
	function close:tap()
		if scene.isShowingComment == true then return true end

		Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04'} )
		local function onComplete()
			composer.hideOverlay(0)
		end
		transition.cancel(logPage)
		transition.to( logPage, { xScale = 0.01, yScale = 0.01, x = 300, y = 20, time = 150 } )
		transition.to( logPage, { alpha = 0, delay = 130, time = 50, onComplete = onComplete })
	end
	close:addEventListener( 'tap', close )

	local function onRowRender( event )
		local id = event.row.id
		local entry = createLogEntryDisplay( log[ tonumber(id) ], id )
		entry.y = 32.5
		event.row:insert(entry)
	end

	local logTable = widget.newTableView( {
		width = 320,
		height = 440,
		backgroundColor = {1,1,1},
		noLines = false,
		onRowRender = onRowRender,
		} )
	logPage:insert( logTable )
	logTable.x = 0
	logTable.y = 20

	self.logTable = logTable

	for i = 1,#log do
		logTable:insertRow( {
			rowHeight = 65,
			rowColor = {1,1,1},
			lineColor = {.8,.8,1},
		} )
	end


	logPage.x = 300
	logPage.y = 20
	logPage.xScale = 0.01
	logPage.yScale = 0.01
	logPage.alpha = 0
end
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

    	transition.to( self.logPage, { alpha = 1, time = 20 })
    	transition.to( self.logPage, { x = 160, y = 240, xScale = 1, yScale = 1, delay = 25, time = 150 })


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