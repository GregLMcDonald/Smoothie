

-----------------------------------------------------------------------------------------
--
-- Title:  scene_Home.lua
--
-- Author: Greg McDonald
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Recipe = require 'Recipe'
local IngredientDisplayObject = require 'IngredientDisplayObject'
local DraggableIngredientDisplayObject = require 'DraggableIngredientDisplayObject'
local Ingredients = require 'Ingredients'

local Language = require 'Language'
local preferredLanguage = Language.getPreference()
print('preferredLanguage',preferredLanguage)

local function addAppliancesToScene()

	local sceneGroup = scene.view

	local appliances = {
    	require( 'Appliance.Blender' ).new(),
    	require( 'Appliance.Dummy' ).new(),
    	require( 'Appliance.Dummy' ).new(),
    	require( 'Appliance.Dummy' ).new(),
    	require( 'Appliance.Blender' ).new(),
    }

    local shelfY = display.contentHeight - 95
    local applianceWidthOnShelf = 0.25 * appliances[1].width
    local shelfHorizontalPadding = (display.contentWidth - #appliances * applianceWidthOnShelf) / (#appliances + 1)
    local shelfX = shelfHorizontalPadding + 0.5 * applianceWidthOnShelf 
    for i = 1, #appliances do
    	local appliance = appliances[ i ]

    	
    	appliance:setActivePosition( 218, 230 )
    	appliance:setShelfScale( 0.25 )
    	appliance:setShelfPosition( shelfX, shelfY )

    	local outline = display.newRoundedRect( shelfX, shelfY, applianceWidthOnShelf+5, applianceWidthOnShelf+5, 5 )
    	outline:setStrokeColor( 0 )
    	outline.strokeWidth = 1
    	sceneGroup:insert(outline)
    	sceneGroup:insert( appliance )

    	shelfX = shelfX + applianceWidthOnShelf + shelfHorizontalPadding
    	appliance:setOnShelf( true, { animate = false } )


    	function appliance:tap()

    		if appliance:isOnShelf() then

    			Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )

    			if scene.currentAppliance then

    				transition.cancel( scene.currentAppliance )

    				for i = 1, #scene.currentAppliance.contents do
						local ingredient = scene.currentAppliance.contents[ i ]
						appliance:addIngredient( ingredient )    					
    				end
    				scene.currentAppliance:empty()
    				scene.currentAppliance:setOnShelf( true )

    			end

    			scene.currentAppliance = appliance
    			appliance:setOnShelf( false )
    			
    		end
    	end
    	appliance:addEventListener( 'tap', appliance )



    end



    scene.currentAppliance = appliances[ 1 ]
    scene.currentAppliance:setOnShelf( false, { animate = false } )
end
local function addIngredientsChooserToScene()
	local sceneGroup = scene.view

	local width = 114
	local height = 300

	local widget = require 'widget'
	local ingredientsChooser = widget.newScrollView( {
		width = width,
		height = height,
		verticalScrollDisabled = true ,
		backgroundColor = { 1, 1, 1 },
		} )
	ingredientsChooser.x = 2 + 0.5 * width
	ingredientsChooser.y = 50 + 0.5 * height

	sceneGroup:insert( ingredientsChooser )

	local chooserOutline = display.newRoundedRect( 0, 0, 118, 304, 5 )
	chooserOutline:setStrokeColor( 0 )
	chooserOutline.strokeWidth = 1
	chooserOutline.fill = nil
	chooserOutline.x = ingredientsChooser.x
	chooserOutline.y = ingredientsChooser.y
	sceneGroup:insert( chooserOutline )


	function ingredientsChooser:getPositionInParentCoordinatesOfPoint(x,y)
		local xInParent
		local yInParent

		local contentX 
		local contentY
		contentX, contentY = self:getContentPosition( )

		xInParent = self.x - 0.5 * width + x + contentX 
		yInParent = self.y - 0.5 * height + y + contentY

		return xInParent, yInParent
	end

	

    local ingredientList
    local ingredientListKeys
    ingredientList, ingredientListKeys = Ingredients.getList()


    local yBase = 35
    local yStep = 55

    local xBase = 5 + 25
    local xStep = 55

   local maxIndex = #ingredientListKeys

    for i = 1, maxIndex do

    	local key = ingredientListKeys[ i ]
    	local _ingredient = ingredientList[ key ]

    	local x = xBase + ( math.floor( (i-1) / 5 ) * xStep )

    	local y = yBase + ( (i-1) % 5 ) * yStep

    	local _ingredientDisplayObject = IngredientDisplayObject.new( _ingredient )

    	_ingredientDisplayObject.x = x
    	_ingredientDisplayObject.y = y

    	y = y + yStep

    	ingredientsChooser:insert( _ingredientDisplayObject )

    	function _ingredientDisplayObject:touch( event )
    		
    		if 'began' == event.phase then

    			Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )

   
   				Runtime:dispatchEvent( { name = 'changeInDraggedIngredient', oldLabel = '', newLabel = self.ingredient[ preferredLanguage ].sampleForm } )
    			
    			local x
    			local y
    			x,y = ingredientsChooser:getPositionInParentCoordinatesOfPoint(self.x,self.y)

    			local _sample = DraggableIngredientDisplayObject.new( self.ingredient, x, y, event.x, event.y )
    			
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

    					Runtime:dispatchEvent( { name = 'changeInDraggedIngredient', oldLabel = self.ingredient[ preferredLanguage ].sampleForm, newLabel = '' } )

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
    		return true
    	end
    	_ingredientDisplayObject:addEventListener( 'touch', _ingredientDisplayObject )
    end
end
local function addIngredientLabelToScene()
	local sceneGroup = scene.view

	local ingredientLabel = display.newText( {
		text = 'Ingredient',
		fontSize = 20,
		width = 200,
		align = 'center',
		})
	ingredientLabel:setFillColor( 0 )
	ingredientLabel.x = 218
	ingredientLabel.y = 100
	ingredientLabel.preferedSize = 20

	function ingredientLabel:changeInDraggedIngredient( event )
		local oldLabel = event.oldLabel or ''
		local newLabel = event.newLabel or ''

		transition.cancel( ingredientLabel )
		ingredientLabel.alpha = 0
		ingredientLabel.text = newLabel
		ingredientLabel.size = ingredientLabel.preferedSize
		transition.to( ingredientLabel, {alpha = 1, time = 350 })


		local oldLabelObject = display.newText( {
		text = oldLabel,
		fontSize = 20,
		width = 200,
		align = 'center',
		})
		ingredientLabel:setFillColor( 0 )
		ingredientLabel.x = 218
		ingredientLabel.y = 100
		transition.to( oldLabelObject, { alpha = 0, time = 350, onComplete = function() oldLabelObject:removeSelf() end  })



	end
	Runtime:addEventListener( 'changeInDraggedIngredient', ingredientLabel )

end

function scene:create( event )

    local sceneGroup = self.view

    local bleed = display.newRect(display.contentCenterX, display.contentCenterY, 1.25 * display.contentWidth, 1.25 * display.contentHeight)
    bleed:setFillColor( 1 )
    sceneGroup:insert( bleed )

    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 1 )
    sceneGroup:insert( background )


  	addAppliancesToScene()

    addIngredientsChooserToScene()
    addIngredientLabelToScene()

    
    local ingredientList
    local ingredientListKeys
    ingredientList, ingredientListKeys = Ingredients.getList()

    self.customer = require( 'Customer' ).new( ingredientList )
    for k,v in pairs(self.customer.preferences) do
    	print(k,v)
    end

    local button = display.newRect( 0, 0, 200, 60 )
    button:setFillColor( 0,1,0 )
    button.x = display.contentCenterX
    button.y = display.contentHeight - 0.5 * button.contentHeight
    sceneGroup:insert(button)

    function button:touch( event )
    	if 'ended' == event.phase then
    		if scene.currentAppliance then 

    			local onProcessingCompleted = function()
    				
    				local recipe = Recipe.new( scene.currentAppliance.contents, scene.currentAppliance.action )
    				
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