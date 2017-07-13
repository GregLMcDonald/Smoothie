local Appliance = {}

local width = 160
local height = 160

local maxContents = 5

function Appliance.new()

	local result = display.newGroup( )
	result.contents = {}
	result.fillingObjects = {}
    result.isOver = false
    result.overImage = nil
    result.width = width
    result.height = height
    result.action = ''
    result.isLocked = false
    result.imageFilename = nil
    
    result.type = 'appliance'
    result.actionPresent = ''
    result.actionPast = ''


    local isOnShelf = false


    local shelfX = 0
    local shelfY = 0
    function result:setShelfPosition( x, y )
        shelfX = x
        shelfY = y
    end
    local shelfScale = 1
    function result:setShelfScale( scale )
        shelfScale = scale
    end

    local activeX = 0
    local activeY = 0
    function result:setActivePosition( x, y )
        activeX = x
        activeY = y
    end
    local activeScale = 1
    function result:setActiveScale( scale )
        activeScale = scale
    end

    function result:setOnShelf( state, options )
        
        local options = options or {}

        local transitionTime = 300
        if options.animate == false then
            transitionTime = 0
        end

        if state == true then
            
            local function onComplete()
                self:setPosition( shelfX, shelfY )
            end
            transition.to( self, { x = shelfX, y = shelfY, xScale = shelfScale, yScale = shelfScale, time = transitionTime, transition = easing.outBack, onComplete = onComplete })
            
        else

            local function onComplete()
                self:setPosition( activeX, activeY )
            end
            transition.to( self, { x = activeX, y = activeY, xScale = activeScale, yScale = activeScale, time = transitionTime, transition = easing.outBack, onComplete = onComplete })
            
        end

        isOnShelf = state

    end
    function result:isOnShelf()
        return isOnShelf
    end

    function result:setLocked( state, time )
        if self.lockImage == nil then
            local lockImage = display.newImageRect( '__image/appliances/lock.png', width, height )
            if lockImage then
                self.lockImage = lockImage
                self:insert( lockImage )
                lockImage:toFront( )
            end
        end
    end
    function result:empty()
    	for i = 1, #self.fillingObjects do
    		local obj = self.fillingObjects[ i ]
    		transition.cancel( obj )
    		transition.to( obj, {alpha = 0, time = 50 })
    	end
    	self.contents = {}
    end

    function result:isFull()
        return #self.contents >= maxContents
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


    function result:removeLastIngredient()
        if #self.contents == 0 then
            return true
        else

            local obj = self.fillingObjects[ #self.contents ]
            if obj then
                transition.cancel( obj )
                transition.to( obj, { alpha = 0, time = 150 } )
            end

            self.contents[ #self.contents ] = nil

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

    function result:setPosition( x, y )
        self.x = x
        self.y = y
        self.minX = x - 0.5 * width
        self.maxX = x + 0.5 * width
        self.minY = y - 0.5 * height
        self.maxY = y + 0.5 * height
    end
    result:setPosition(0,0)

    function result:containsPoint( x, y )
        if x >= self.minX and x <= self.maxX and y >= self.minY and y <= self.maxY then
            return true
        else
            return false
        end
    end

    function result:remove( )
        for i = #self.fillingObjects, 1, -1 do
            table.remove( self.fillingObjects, i)
        end
        display.remove( self )
    end

    function result:processContents( onCompletion )

        local _recipe = require( '_Culinary.Recipe' ).new( self.contents, self.action )
    
        if onCompletion and 'function' == type(onCompletion) then
            onCompletion()
        end


    end

    function result:getLiteCopy()
        local liteCopy = {}

        liteCopy.action = self.action
        liteCopy.imageFilename = self.imageFilename

        return liteCopy
    end


    return result
    
end


return Appliance