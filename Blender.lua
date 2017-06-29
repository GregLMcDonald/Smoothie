local Blender = {}

local blenderWidth = 200
local blenderHeight = 200

function Blender.new()

	local result = display.newGroup( )
	result.contents = {}
	result.fillingObjects = {}

	local blenderImage = display.newImageRect( 'image/mixer.png', blenderWidth, blenderHeight )
    result:insert( blenderImage )

    for i = 1, 10 do
    	print(i)
    	local fillingName = 'image/mixer_fill_'..tostring(i)..'.png'
    	local filling = display.newImageRect( fillingName, blenderWidth, blenderHeight )
    	filling.alpha = 1
    	filling:setFillColor( i * 0.1 )
    	result:insert( filling )

    	table.insert( result.fillingObjects, filling )

    end


    function result:empty()
    	for i = 1, #self.fillingObjects do
    		local obj = self.fillingObjects[ i ]
    		transition.cancel( obj )
    		transition.to( obj, {alpha = 0, time = 50 })
    	end
    	result.contents = {}
    end

    function result:addIngredient( ingredient )

    	if #self.contents >= 10 then 
    		return false 
    	else

    		table.insert( self.contents, ingredient )

    		local obj = self.fillingObjects[ #self.contents ]
    		obj:setFillColor( unpack( ingredient.colour ) )
    		transition.cancel( obj )
    		transition.to( obj, {alpha = 1, time = 50 })
    		
    	end
    	return true
    end



    return result
    
end


return Blender