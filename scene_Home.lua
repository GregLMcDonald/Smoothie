
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
    background:setFillColor( 1,.98,.98 )
    sceneGroup:insert( background )


    local blender = require( 'Blender' ).new()
    self.appliance = blender

    blender:setPoint( display.contentCenterX, display.contentCenterY )
  	sceneGroup:insert( blender  )


    local IngredientDisplayObject = require 'IngredientDisplayObject'
    local ingredientList = require 'ingredientList'

    local yBase = 50
    local yStep = 55

    local maxIndex = math.min( #ingredientList.orderedKeys, 10 )

    for i = 1, maxIndex do

    	local key = ingredientList.orderedKeys[ i ]
    	local _ingredient = ingredientList[ key ]

    	local x
    	if i <= 5 then
    		x = 40
    	else
    		x = display.contentWidth - 40
    	end

    	local y = yBase + ( (i-1) % 5 ) * yStep

    	local _ingredientDisplayObject = IngredientDisplayObject.new( _ingredient )

    	_ingredientDisplayObject.x = x
    	_ingredientDisplayObject.y = y

    	y = y + yStep

    	sceneGroup:insert( _ingredientDisplayObject )

    	function _ingredientDisplayObject:touch( event )
    		
    		if 'began' == event.phase then

    			local _sample = require( 'DraggableIngredientDisplayObject' ).new( self.ingredient, self.x, self.y, event )
    			
    			sceneGroup:insert( _sample )
    			_sample:toFront( )

    			_sample.xScale = 0.2
    			_sample.yScale = 0.2

    			transition.to( _sample, { xScale = 1.1, yScale = 1.1, time = 1000, transition = easing.outElastic } )

    			Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )


    			function _sample:touch( event )


    				if 'moved' == event.phase then

    					self:handleTouchMoved( event )
    					
    					if blender:containsPoint( self.x, self.y ) then
    					 	if blender.isOver == false then
    							blender:setOver( true )
    						end
    					else
    						if blender.isOver == true then
    							blender:setOver( false)
    						end
    					end
    					

    				elseif 'ended' == event.phase then

    					self:handleTouchEnded( event )

    					blender:setOver( false )
    					if blender:containsPoint( self.x, self.y ) then

    						self:handleAdded( blender.x, blender.y )
    						
    						blender:addIngredient( self.ingredient )

    						if self.ingredient.name == 'TACO' then
    							blender:empty()
    						end

    					else

    						self:handleUnused()


    					end

    					

    				end

    			end
    			_sample:addEventListener( 'touch', _sample )

    			local stage = display.getCurrentStage( )
    			stage:setFocus( _sample  )

    		end
    	end
    	_ingredientDisplayObject:addEventListener( 'touch', _ingredientDisplayObject )
    end


    local button = display.newRect( 0, 0, 100, 75 )
    button:setFillColor( 0,1,0 )
    button.x = display.contentCenterX
    button.y = display.contentHeight - 0.5 * button.contentHeight - 10
    sceneGroup:insert(button)

    function button:touch( event )
    	if 'ended' == event.phase then
    		scene.appliance:processContents()
    	end
    end
    button:addEventListener( 'touch', button )

   


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