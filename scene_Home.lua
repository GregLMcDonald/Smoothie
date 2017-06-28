
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

    local blender = display.newRect(0,0, 0.5 * display.contentWidth, 0.5 * display.contentHeight )
    blender:setFillColor( 0.8 )
    blender:setStrokeColor( 0 )
    blender.strokeWidth = 1
    blender.x = display.contentCenterX
    blender.y = display.contentCenterY
    blender.minX = blender.x - 0.5 * blender.contentWidth
    blender.maxX = blender.x + 0.5 * blender.contentWidth
    blender.minY = blender.y - 0.5 * blender.contentHeight
    blender.maxY = blender.y + 0.5 * blender.contentHeight
    function blender:containsPoint(x,y)
    	if x >= self.minX and x <= self.maxX and y >= self.minY and y <= self.maxY then
    		return true
    	else
    		return false
    	end
	end

    sceneGroup:insert( blender )


    local ingredients = {
    	'spaghetti',
    	'kale',
    	'carrot',
    	'cocoa',
    	'banana',
    	'spinach',
    	'almond milk',
    	'celery',
    	'chia',
    	'spirulina',
    }


    local Ingredient = require 'Ingredient'

    local yBase = 50
    local yStep = 60

    for i = 1, #ingredients do

    	local x
    	if i <= 5 then
    		x = 40
    	else
    		x = display.contentWidth - 40
    	end

    	local y = yBase + ( (i-1) % 5 ) * yStep

    	local _ingredient = Ingredient.new( { name = ingredients[ i ] } )
    	_ingredient.x = x
    	_ingredient.y = y
    	y = y + yStep
    	sceneGroup:insert( _ingredient )

    	function _ingredient:touch( event )
    		
    		if 'began' == event.phase then

    			local _sample = Ingredient.new( { name = self.name, colour = {1,0,0} } )
    			_sample.x = self.x
    			_sample.y = self.y
    			_sample.originalX = self.x
    			_sample.originalY = self.y
    			sceneGroup:insert( _sample )
    			_sample:toFront( )

    			_sample.xScale = 0.2
    			_sample.yScale = 0.2

    			transition.to( _sample, { xScale = 1, yScale = 1, time = 600, transition = easing.outElastic } )

    			function _sample:touch( event )
    				if 'moved' == event.phase then

    					self.x = event.x
    					self.y = event.y

    				elseif 'ended' == event.phase then

    					transition.cancel( self )

    					if blender:containsPoint( self.x, self.y ) then

    						print("adding "..self.name.." to mixture")
    						transition.to (self, { x = display.contentCenterX, y = display.contentCenterY, xScale = 0.1, yScale = 0.1, time = 150, onComplete = function() self:removeSelf() end })

    					else

    						transition.to (self, { x = self.originalX, y = self.originalY, xScale = 0.1, yScale = 0.1, time = 150, onComplete = function() self:removeSelf() end })

    					end

    					

    				end

    			end
    			_sample:addEventListener( 'touch', _sample )

    			local stage = display.getCurrentStage( )
    			stage:setFocus( _sample  )

    		end
    	end
    	_ingredient:addEventListener( 'touch', _ingredient )

    end




   


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