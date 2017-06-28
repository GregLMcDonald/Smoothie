-----------------------------------------------------------------------------------------
--
-- Title:  scene_Home.lua
--
-- Author: Greg McDonald
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()


function scene:create( event )

    local sceneGroup = self.view

    local bleed = display.newRect(display.contentCenterX, display.contentCenterY, 1.25 * display.contentWidth, 1.25 * display.contentHeight)
    bleed:setFillColor( 0.3 )
    sceneGroup:insert( bleed )

    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 0.6 )
    sceneGroup:insert( background )


    local Ingredient = require 'Ingredient'

    local y = 50
    local yStep = 60

	local default = Ingredient.new()
	default.x = display.contentCenterX
	default.y = y
	sceneGroup:insert( default )

	y = y + yStep

	local goo = Ingredient.new( { name = 'spinach', colour = {0,1,0} } )
	goo.x = display.contentCenterX
	goo.y = y
	sceneGroup:insert( goo )

	y = y + yStep

	local apple = Ingredient.new( { name = 'apple', colour = {1,0,0} } )
	apple.x = display.contentCenterX
	apple.y = y
	sceneGroup:insert( apple )




end



function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then
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