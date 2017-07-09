local Blender = {}

local blenderWidth = 200
local blenderHeight = 200

function Blender.new()

	local result = require( 'Appliance' ).new()
	result.action = 'blended'
	
	local blenderImage = display.newImageRect( 'image/mixer.png', blenderWidth, blenderHeight )
    result:insert( blenderImage )

    result.overImage = display.newImageRect( 'image/mixer_darker_container.png', blenderWidth, blenderHeight)
    result:insert( result.overImage )
    result.overImage.alpha = 0

    for i = 1, 5 do
    	local fillingName = 'image/mixer_fill_max5_'..tostring(i)..'.png'
    	local filling = display.newImageRect( fillingName, blenderWidth, blenderHeight )
    	filling.alpha = 0
    	result:insert( filling )
    	table.insert( result.fillingObjects, filling )
    end



    function result:processContents( completionHandler )

        local soundKey = 'process_Blend'
        local sound = require( 'Sound' )
        local duration = sound:getDuration( soundKey )
        Runtime:dispatchEvent( { name = 'soundEvent', key = soundKey } )

        --print("WARNING: DEBUG blend time set to 0")
        --duration = 0


        -- Compute average colour of ingredients
        local red = 0
        local green = 0
        local blue = 0
        for i = 1,#self.contents do
        	local ingredient = self.contents[ i ]
        	local colour = ingredient.colour
        	red = red + colour[ 1 ]
        	green = green + colour[ 2 ]
        	blue = blue + colour[ 3 ]
        end
        if #self.contents > 0 then 
        	red = red / #self.contents 
        	green = green / #self.contents
        	blue = blue / #self.contents
        end

        -- Animate transition to new colour
        for i = 1, #self.contents do
      
        	local ingredient = self.contents[ i ]

    		local fillingName = 'image/mixer_fill_max5_'..tostring(i)..'.png'
    		local filling = display.newImageRect( fillingName, blenderWidth, blenderHeight )
    		if filling then
    			filling:setFillColor( unpack( ingredient.colour ) )
    			filling.alpha = 1
    			result:insert( filling )
    			filling:toFront( )

    			self.fillingObjects[ i ]:setFillColor( red, green, blue )

    			transition.to( filling, { alpha = 0, time = duration, onComplete = function() filling:removeSelf() end })
    		end

    	end

    	if completionHandler and 'function' == type(completionHandler) then
    		
    		timer.performWithDelay( duration + 100, completionHandler )
    	end
     
    end

    return result
    
end


return Blender