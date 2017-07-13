

-----------------------------------------------------------------------------------------
--
-- Title:  Play.lua
--
-- Author: Greg McDonald
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local Recipe = require '_Culinary.Recipe'
local IngredientDisplayObject = require '_Culinary.IngredientDisplayObject'
local DraggableIngredientDisplayObject = require '_Culinary.DraggableIngredientDisplayObject'
local Ingredients = require '_Culinary.Ingredients'

local Language = require '_Assets.Language'
local preferredLanguage = Language.getPreference()

local function addBleed()
    local sceneGroup = scene.view
    local bleedBottom = display.newRect(display.contentCenterX, display.contentCenterY, 1.25 * display.contentWidth, 1.25 * display.contentHeight)
    --bleedBottom:setFillColor( .8,.8,1  )
    bleedBottom:setFillColor( 1 )
    sceneGroup:insert( bleedBottom )

    local bleedTop = display.newRect(display.contentCenterX, 0, 1.25 * display.contentWidth, 100)
    --bleedTop:setFillColor( 1,.8,.8  )
      bleedTop:setFillColor( 0 )
    sceneGroup:insert( bleedTop )
end
local function addBackground()

    local sceneGroup = scene.view
    local backgroundTop = display.newRect( 160, 25, 320, 50)
    backgroundTop:setFillColor( 0 )
    sceneGroup:insert( backgroundTop )

    local backgroundBottom = display.newRect( 160, 265, 320, 430 )
    backgroundBottom:setFillColor( 1 )
    sceneGroup:insert( backgroundBottom )
end
local function addAppliances()

	local sceneGroup = scene.view

	local appliances = {
    	require( '_Appliance.Dummy' ).new(),
        require( '_Appliance.Blender' ).new(),
    	require( '_Appliance.Grinder' ).new(),
    	require( '_Appliance.Press' ).new(),
    	require( '_Appliance.Dummy' ).new(),
    }

    local shelfY = display.contentHeight - 75
    local applianceWidthOnShelf = 0.25 * appliances[1].width

    local shelfHorizontalPadding = (display.contentWidth - #appliances * applianceWidthOnShelf) / (#appliances + 1)
    local shelfX = shelfHorizontalPadding + 0.5 * applianceWidthOnShelf 
    for i = 1, #appliances do
    	local appliance = appliances[ i ]

    	
    	appliance:setActivePosition( 160, 295 )
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

                if scene.actionButton then                    
                    scene.actionButton:changeActionLabel( appliance.actionPresent )
                end
    			
    		end
    	end
    	appliance:addEventListener( 'tap', appliance )



    end



    scene.currentAppliance = appliances[ 1 ]
    scene.currentAppliance:setOnShelf( false, { animate = false } )
end
local function addIngredientsChooser()
	local sceneGroup = scene.view

	local width = 320
	local height = 160

	local widget = require 'widget'
	local ingredientsChooser = widget.newScrollView( {
		width = width,
		height = height,
		verticalScrollDisabled = true ,
		backgroundColor = { 1, 1, 1 },
		} )
	ingredientsChooser.x = 0.5 * width
	ingredientsChooser.y = 50 + 0.5 * height

	sceneGroup:insert( ingredientsChooser )

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


    local yBase = 30
    local yStep = 50

    local xBase = 5 + 25
    local xStep = 55

   local maxIndex = #ingredientListKeys
   local ingredientsPerColumn = 3

    for i = 1, maxIndex do

    	local key = ingredientListKeys[ i ]
    	local _ingredient = ingredientList[ key ]

    	local x = xBase + ( math.floor( (i-1) / ingredientsPerColumn ) * xStep )

    	local y = yBase + ( (i-1) % ingredientsPerColumn ) * yStep

        local isIngredientLocked = scene.preferences[ key ]
   
    	local _ingredientDisplayObject = IngredientDisplayObject.new( _ingredient, { isLocked = isIngredientLocked } )

    	_ingredientDisplayObject.x = x
    	_ingredientDisplayObject.y = y

    	y = y + yStep

    	ingredientsChooser:insert( _ingredientDisplayObject )

    	function _ingredientDisplayObject:touch( event )

            if self.isLocked == true then
                return false
            end

    		
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

                                if scene.emptyApplianceButton.isEnabled == false then
                                    scene.emptyApplianceButton:setEnabled( true )
                                end

                                if scene.undoButton.isEnabled == false then
                                    scene.undoButton:setEnabled( true )
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
local function addIngredientLabel()
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
    sceneGroup:insert( ingredientLabel )

	function ingredientLabel:changeInDraggedIngredient( event )
		local oldLabel = event.oldLabel or ''
		local newLabel = event.newLabel or ''

		transition.cancel( self )
		self.alpha = 0
		self.text = newLabel
		self.size = self.preferedSize
		transition.to( self, {alpha = 1, time = 150 })


		local oldLabelObject = display.newText( {
		text = oldLabel,
		fontSize = self.preferedSize,
		width = 200,
		align = 'center',
		})
		oldLabelObject:setFillColor( 0 )
		oldLabelObject.x = 218
		oldLabelObject.y = 100
		transition.to( oldLabelObject, { alpha = 0, time = 150, onComplete = function() oldLabelObject:removeSelf() end  })



	end
	Runtime:addEventListener( 'changeInDraggedIngredient', ingredientLabel )
end
local function addMuteButton()
    local muteButton = require( '_UI.MuteButton' ).new()

    muteButton.x = 64
    muteButton.y = 455
    scene.view:insert(muteButton)
    scene.muteButton = muteButton
    if 0 == audio.getVolume() then
        muteButton:setMuted( true, 0)
    else
        muteButton:setMuted( false, 0 )
    end
    function muteButton:tap()
        muteButton:setMuted( not muteButton.isMuted )
    end
    muteButton:addEventListener( 'tap', muteButton )
end
local function addEmptyApplianceButton()

    local emptyApplianceButton = require( '_UI.EmptyApplianceButtonWidget' ).new()
    scene.emptyApplianceButton = emptyApplianceButton
    emptyApplianceButton:setEnabled( false, 0 )
    emptyApplianceButton.x = 270
    emptyApplianceButton.y = 350
    scene.view:insert( emptyApplianceButton )
end
local function addUndoButton()
    local undoButton = require( '_UI.UndoButtonWidget' ).new()
    scene.undoButton = undoButton
    undoButton:setEnabled( false, 0 )
    undoButton.x = 270
    undoButton.y = 300
    scene.view:insert(undoButton)
end
local function addCustomerAndCustomerPanel()
    
    local ingredientList
    local ingredientListKeys
    ingredientList, ingredientListKeys = Ingredients.getList()

    scene.customer = require( '_Customer.Customer' ).new( ingredientList )

    local customerPanel = require('_UI.CustomerPanel').new( scene.customer )
    customerPanel.x = -200
    customerPanel.y = 25
    customerPanel.alpha = 0
    scene.customerPanel = customerPanel
    scene.view:insert( customerPanel )
end
local function addHomeButton()
    local homeButton = display.newImageRect( '__image/ui/arrows.png', 40, 40 )
    homeButton.x = 22
    homeButton.y = 455
    scene.view:insert( homeButton )
    function homeButton:tap()
        Runtime:dispatchEvent( { name = 'soundEvent', key = 'Alert_03'})
        composer.gotoScene( '_Scene.Title', { effect = 'crossFade', time = 300 } )
    end
    homeButton:addEventListener( 'tap', homeButton )
end

local function addActionButton()

    local button = display.newGroup( )

    local buttonShape = display.newRoundedRect( 0, 0, 200, 40, 5)
    buttonShape:setFillColor( 37/255, 185/255, 154/255 )
    button:insert( buttonShape )
    
    local function getButtonLabelObject( text )

        local buttonLabel = display.newText({
            text = string.upper( text ),
            fontSize = 30,
            font = 'HAMBH___.ttf',
            })
        buttonLabel:setFillColor( 1 )
        
        return buttonLabel

    end

    local labelText = 'process!'
    if scene.currentAppliance and scene.currentAppliance.actionPresent then
        labelText = scene.currentAppliance.actionPresent..'!'
    end


    local buttonLabel = getButtonLabelObject( labelText )
    button.buttonLabel = buttonLabel
    button:insert( buttonLabel )


    button.x = 210
    button.y = display.contentHeight - 25
    scene.actionButton = button
    scene.view:insert(button)

    function button:touch( event )
        if 'ended' == event.phase then
            if scene.currentAppliance then 

                local onProcessingCompleted = function()

                    local contentsCopy = {}
                    for i=1, #scene.currentAppliance.contents do
                        local ingredient = scene.currentAppliance.contents[ i ]
                        local ingredientCopy = Ingredients.copyIngredient( ingredient )
                        table.insert( contentsCopy, ingredientCopy )
                    end


                    -- scene.currentAppliance:empty()
                    
                    local recipe = Recipe.new( contentsCopy, scene.currentAppliance:getLiteCopy() )
                    
                    if scene.customer then
                        local rating = scene.customer:rateRecipe( recipe )
                        scene.customer:addToLog( recipe, rating, "" )

                        if scene.customerPanel then
                            scene.customerPanel:setRating( rating )
                            scene.customerPanel:setLogButtonEnabled( true )
                        end

                    end
                end

                scene.currentAppliance:processContents( onProcessingCompleted )
                

            end
        end
    end
    button:addEventListener( 'touch', button )

    function button:changeActionLabel( action )
        
        local newText = string.upper( action..'!')
        if newText ~= self.buttonLabel.text then

            local temp = getButtonLabelObject( self.buttonLabel.text )
            self:insert( temp )
            transition.to( temp, { alpha = 0, time = 100, onComplete = function() temp:removeSelf() end })

            transition.cancel( self )
            self.buttonLabel.alpha = 0
            self.buttonLabel.text = newText
            transition.to( self.buttonLabel, { alpha = 1, time = 100 })

        end
    end
end


function scene:create( event )

    self.preferences = require( '_Assets.Preferences' ).getCopy()

    local sceneGroup = self.view
    
    addBleed()
    addBackground()
    addIngredientsChooser()
    addAppliances()
    -- addIngredientLabel()

    addEmptyApplianceButton()
    addUndoButton()
    addHomeButton()
   -- addMuteButton()
    addCustomerAndCustomerPanel()
    addActionButton()
   
    Runtime:addEventListener( "key", self )
end
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    elseif ( phase == "did" ) then

        Runtime:addEventListener( 'logButtonTapped', self )
        Runtime:addEventListener( 'emptyApplianceButtonTapped', self )
        Runtime:addEventListener( 'undoButtonTapped', self )

        local customerPanel = self.customerPanel
        if customerPanel then
            timer.performWithDelay( 300, function()
                transition.to( customerPanel, { alpha = 1, time = 50 })
                transition.to( customerPanel, { x = display.contentCenterX, time = 1000, transition = easing.outElastic } ) 
            end )
        end

        if self.muteButton then
            if 0 == audio.getVolume() then
                self.muteButton:setMuted( true, 0)   
            else
                self.muteButton:setMuted( false, 0 )
            end
        end

        composer.removeScene( '_Scene.LogOverlay' )


    end
end
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        local sound = require '_Assets.Sound'
        sound.duckBackgroundMusic()
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


function scene:logButtonTapped( event )

    Runtime:dispatchEvent( { name = 'soundEvent', key = 'Maximise_08' } )

    local log
    if scene.customer then
        log = scene.customer.log
    end
    composer.showOverlay( '_Scene.LogOverlay' , { isModal = true, time = 0, params = { log = log} })
end
function scene:emptyApplianceButtonTapped( event )
    if self.currentAppliance then
        self.currentAppliance:empty()
    end
    if self.undoButton then
        self.undoButton:setEnabled( false )
    end
    if self.emptyApplianceButton then
        self.emptyApplianceButton:setEnabled( false )
    end
end
function scene:undoButtonTapped( event )
    if self.currentAppliance then
        self.currentAppliance:removeLastIngredient()
    end
    if #self.currentAppliance.contents == 0 then
        if self.undoButton then 
            self.undoButton:setEnabled( false )
        end
        if self.emptyApplianceButton then
            self.emptyApplianceButton:setEnabled( false )
        end
    end
end
function scene:key(event)
    local handledTouch = false
    if ( event.keyName == "back" ) then
       local platformName = system.getInfo( "platformName" )
       if ( platformName == "Android" ) or ( platformName == "WinPhone" ) then
         
            if event.phase == "up" then

                    composer.gotoScene( '_Scene.Title' )
                    handledTouch = true

            end
        end
    end
    return handledTouch
end

return scene