-- overlay_Log.lua

local composer = require( "composer" )
local scene = composer.newScene()

local widget = require 'widget'
local IngredientDisplayObject = require 'IngredientDisplayObject'

local bookColour = { 37/255, 185/255, 154/255 }

local function createLogEntryDisplay( entry )
	
	local recipe = entry.recipe
	local rating = entry.rating
	local comments = entry.comments 

	local result = display.newGroup()

	for i=1,#recipe.ingredients do
		local obj = IngredientDisplayObject.new( recipe.ingredients[ i ] )

		obj.xScale = 0.8
		obj.yScale = 0.8

		obj.x = 20 + (i-1)*40
		result:insert( obj )

	end

	return result


end



function scene:create( event )

	local log = event.params.log

	print('LOG ',log,#log )


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


	local close = display.newImageRect( 'image/ui/kitchen.png', 30, 30 )
	close.x = 140
	close.y = -220
	logPage:insert( close )
	function close:tap()
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
		local entry = createLogEntryDisplay( log[ tonumber(id) ] )
		entry.y = 25
		event.row:insert(entry)
	end

	local logTable = widget.newTableView( {
		width = 320,
		height = 440,
		backgroundColor = {.8,1,.8},
		noLines = false,
		onRowRender = onRowRender,
		} )
	logPage:insert( logTable )
	logTable.x = 0
	logTable.y = 20

	for i = 1,#log do
		logTable:insertRow( {
			rowHeight = 50,
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