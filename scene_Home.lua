
-----------------------------------------------------------------------------------------
--
-- Title:  scene_Home.lua
--
-- Author: Greg McDonald
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local soundFilenameSuffix = '.ogg'


local directoryPrefix = "audio/"
local androidSuffix = ".ogg"
local iosSuffix = ".m4a"

local function filenameForBase( base )

	local fn = directoryPrefix..base..androidSuffix
	if system.pathForFile( fn , system.ResourceDirectory ) ~= nil then
    	return fn
    end

    fn = directoryPrefix..base..iosSuffix 
	if system.pathForFile( fn, system.ResourceDirectory ) ~= nil then
    	return fn
    end

    return nil
end


local selectSoundFilename = filenameForBase( 'select')
local selectSoundHandle
if selectSoundFilename then
	selectSoundHandle = audio.loadSound( selectSoundFilename )
end

local releaseSoundFilename = filenameForBase( 'release' )
local releaseSoundHandle 
if releaseSoundFilename then
	releaseSoundHandle = audio.loadSound( releaseSoundFilename )
end

print(selectSoundFilename,selectSoundHandle)
print(releaseSoundFilename,releaseSoundHandle)


function scene:create( event )

    local sceneGroup = self.view

    local bleed = display.newRect(display.contentCenterX, display.contentCenterY, 1.25 * display.contentWidth, 1.25 * display.contentHeight)
    bleed:setFillColor( 0.3 )
    sceneGroup:insert( bleed )

    local background = display.newRect( display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight )
    background:setFillColor( 1,.98,.98 )
    sceneGroup:insert( background )

    local blenderGroup = display.newGroup( )
    local blenderBG = display.newRect(0,0, 0.5 * display.contentWidth, 0.5 * display.contentHeight )
    blenderBG:setFillColor( 0.4 )
    blenderBG:setStrokeColor( 0 )
    blenderBG.strokeWidth = 1

    blenderGroup:insert( blenderBG )

    local blender = require('Blender').new()
  	blenderGroup:insert( blender  )

  	timer.performWithDelay( 2000, function() blender:empty() end )


    blenderGroup.x = display.contentCenterX
    blenderGroup.y = display.contentCenterY
    blenderGroup.minX = blenderGroup.x - 0.5 * blenderBG.contentWidth
    blenderGroup.maxX = blenderGroup.x + 0.5 * blenderBG.contentWidth
    blenderGroup.minY = blenderGroup.y - 0.5 * blenderBG.contentHeight
    blenderGroup.maxY = blenderGroup.y + 0.5 * blenderBG.contentHeight
    function blenderGroup:containsPoint(x,y)
    	if x >= self.minX and x <= self.maxX and y >= self.minY and y <= self.maxY then
    		return true
    	else
    		return false
    	end
	end
	blenderGroup.isOver = false
	function blenderGroup:setOver( state )
		if blenderGroup.isOver == state then return end

		blenderGroup.isOver = state
		if state == true then
			blenderBG:setFillColor( .8 )
		else
			blenderBG:setFillColor( 0.4 )
		end
	end

    sceneGroup:insert( blenderGroup )


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

    			local _sample = IngredientDisplayObject.new( self.ingredient )
    			
    			_sample.x = self.x
    			_sample.y = self.y
    			
    			_sample.xOffset = event.x - self.x
    			_sample.yOffset = event.y - self.y

    			_sample.originalX = self.x
    			_sample.originalY = self.y

    			sceneGroup:insert( _sample )
    			_sample:toFront( )

    			_sample.xScale = 0.2
    			_sample.yScale = 0.2

    			transition.to( _sample, { xScale = 1.1, yScale = 1.1, time = 1000, transition = easing.outElastic } )

    			if selectSoundHandle then
    				audio.play( selectSoundHandle )
    			end

    			function _sample:touch( event )
    				if 'moved' == event.phase then

    					self.x = event.x - self.xOffset
    					self.y = event.y - self.yOffset

    					
    					if blenderGroup:containsPoint( self.x, self.y ) then
    					 	if blenderGroup.isOver == false then
    							blenderGroup:setOver( true )
    						end
    					else
    						if blenderGroup.isOver == true then
    							blenderGroup:setOver( false)
    						end
    					end
    					

    				elseif 'ended' == event.phase then



    					local stage = display.getCurrentStage()
    					stage:setFocus( nil )

    					transition.cancel( self )
    					blenderGroup:setOver( false )


    					if blenderGroup:containsPoint( self.x, self.y ) then

    						if releaseSoundHandle then
    							audio.play( releaseSoundHandle )
    						end

    						print("adding "..self.ingredient.name.." to mixture")
    						transition.to (self, { x = display.contentCenterX, y = display.contentCenterY, xScale = 0.1, yScale = 0.1, time = 150, onComplete = function() self:removeSelf() end })
    						blender:addIngredient( self.ingredient )

    						if self.ingredient.name == 'TACO' then
    							blender:empty()
    						end

    					else

    						if selectSoundHandle then
    							audio.play( selectSoundHandle )
    						end

    						transition.to (self, { x = self.originalX, y = self.originalY, xScale = 0.1, yScale = 0.1, time = 150, onComplete = function() self:removeSelf() end })

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