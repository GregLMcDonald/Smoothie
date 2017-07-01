local Appliance = {}

local width = 200
local height = 200

local maxContents = 10

function Appliance.new()

	local result = display.newGroup( )
	result.contents = {}
	result.fillingObjects = {}
    result.isOver = false
    result.overImage = nil
    result.width = width
    result.height = height


    function result:empty()
    	for i = 1, #self.fillingObjects do
    		local obj = self.fillingObjects[ i ]
    		transition.cancel( obj )
    		transition.to( obj, {alpha = 0, time = 50 })
    	end
    	result.contents = {}
    end

    function result:addIngredient( ingredient )

    	if #self.contents >= maxContents then 
    		return false 
    	else

    		table.insert( self.contents, ingredient )

    		local obj = self.fillingObjects[ #self.contents ]
            if obj then
    		  obj:setFillColor( unpack( ingredient.colour ) )
    		  transition.cancel( obj )
    		  transition.to( obj, {alpha = 1, time = 150 })
            end
    		
    	end
    	return true
    end

    function result:setOver( state )
    	if state == self.isOver then return end
    	
    	self.isOver = state

        if self.overImage then

    	   transition.cancel( self.overImage )
    	   if true == state then
    		  transition.to( self.overImage, { alpha = 1, time = 50 } )
    	   else
    		  transition.to( self.overImage, { alpha = 0, time = 50 } )
    	   end
        end
    end

    function result:setPoint( x, y )
        self.x = x
        self.y = y
        self.minX = x - 0.5 * width
        self.maxX = x + 0.5 * width
        self.minY = y - 0.5 * height
        self.maxY = y + 0.5 * height
    end
    result:setPoint(0,0)

    function result:containsPoint( x, y )
        if x >= self.minX and x <= self.maxX and y >= self.minY and y <= self.maxY then
            return true
        else
            return false
        end
    end

    function result:remove( )
        print('remove( )')
        for i = #self.fillingObjects, 1, -1 do
            table.remove( self.fillingObjects, i)
        end
        display.remove( self )
    end

    function result:processContents( completionHandler )
        print('processContents')
        local function onComplete()
            if completionHandler and 'function' == type(completionHandler) then
                completionHandler()
            end
        end
     
    end


    return result
    
end


return Appliance