local DraggableIngredientDisplayObject = {}


function DraggableIngredientDisplayObject.new( ingredient, x, y, event )

	assert( ingredient, "ingredient cannot be nil in DraggableIngredientDisplayObject.new")
	local result = require( 'IngredientDisplayObject' ).new( ingredient )


	result.x = x
	result.y = y

	result.xOffset = event.x - x
	result.yOffset = event.y - y

	result.originalX = x
	result.originalY = y


	function result:handleTouchMoved( event )

			self.x = event.x - self.xOffset
    		self.y = event.y - self.yOffset		

	end

	function result:handleTouchEnded( event )

		local stage = display.getCurrentStage()
    	stage:setFocus( nil )

    	transition.cancel( self )

	end

	function result:handleUnused()
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )
    	transition.to( self, { 
    		x = self.originalX, 
    		y = self.originalY, 
    		xScale = 0.1, 
    		yScale = 0.1, 
    		time = 150, 
    		onComplete = function() self:removeSelf() end 
    	})
	end

	function result:handleAdded( targetX, targetY )
		Runtime:dispatchEvent( { name = 'soundEvent', key = 'release' } )
    	transition.to( self, { 
    		x = targetX,
    		y = targetY, 
    		xScale = 0.1, 
    		yScale = 0.1, 
    		time = 150, 
    		onComplete = function() self:removeSelf() end 
    	})
	end


	return result

end


return DraggableIngredientDisplayObject