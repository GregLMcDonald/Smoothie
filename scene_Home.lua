
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
    self.currentAppliance = blender


  

    self.currentAppliance:setPoint( display.contentCenterX, display.contentCenterY )
  	sceneGroup:insert( self.currentAppliance  )


    local IngredientDisplayObject = require 'IngredientDisplayObject'
    local Ingredients = require 'Ingredients'

    local ingredientList
    local ingredientListKeys
    ingredientList, ingredientListKeys = Ingredients.getList()

    self.customer = require( 'Customer' ).new( ingredientList )
    for k,v in pairs(self.customer.preferences) do
    	print(k,v)
    end

    local yBase = 50
    local yStep = 55

    local maxIndex = math.min( #ingredientListKeys, 10 )

    for i = 1, maxIndex do

    	local key = ingredientListKeys[ i ]
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

    			Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )
    			
    			local _sample = require( 'DraggableIngredientDisplayObject' ).new( self.ingredient, self.x, self.y, event )
    			
    			sceneGroup:insert( _sample )
    			_sample:toFront( )

    			_sample.xScale = 0.2
    			_sample.yScale = 0.2

    			transition.to( _sample, { xScale = 1.1, yScale = 1.1, time = 1000, transition = easing.outElastic } )

    			function _sample:touch( event )


    				if 'moved' == event.phase then

    					self:handleTouchMoved( event )
    					
    					if scene.currentAppliance then
    						if scene.currentAppliance:containsPoint( self.x, self.y ) then
    							if scene.currentAppliance.isOver == false then
    								scene.currentAppliance:setOver( true )
    							end
    						else
    							if scene.currentAppliance.isOver == true then
    								scene.currentAppliance:setOver( false)
    							end
    						end
    					end
    					

    				elseif 'ended' == event.phase then

    					self:handleTouchEnded( event )

    					if scene.currentAppliance then
    						scene.currentAppliance:setOver( false )
    						if scene.currentAppliance:containsPoint( self.x, self.y ) and false == scene.currentAppliance:isFull() then

    							self:handleAdded( scene.currentAppliance.x, scene.currentAppliance.y )
    						
    							scene.currentAppliance:addIngredient( self.ingredient )

    							if self.ingredient.name == 'honey' then
    								scene.currentAppliance:empty()
    							end

    						else

    							self:handleUnused()


    						end
    					end
    					

    				end
    			end
    			_sample:addEventListener( 'touch', _sample )

    			local stage = display.getCurrentStage( )
    			stage:setFocus( _sample  ) --allows sample to track movement of touch

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
    		if scene.currentAppliance then 

    			local onProcessingCompleted = function()
    				
    				local recipe = require( 'Recipe' ).new( scene.currentAppliance.contents, scene.currentAppliance.action )
    				

    				if scene.customer then
    					local rating = scene.customer:rateRecipe( recipe )
    					print("DEBUG rating",rating)
    				end


    			end

    			scene.currentAppliance:processContents( onProcessingCompleted )
    			

    		end
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