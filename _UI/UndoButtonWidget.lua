local UndoButtonWidget = {}

function UndoButtonWidget.new()
	
	local result = display.newGroup()

	local grayImage = display.newImageRect( '__image/ui/undoGrayWhiteFill.jpg', 40, 40 )
	local colourImage = display.newImageRect( '__image/ui/undoWhiteFill.jpg', 40, 40 )


	result:insert( grayImage )
	result:insert( colourImage )
	
	result.isEnabled = true

	function result:setEnabled( state, time )
		self.isEnabled = state
	
		local time = time or 150
		transition.cancel( colourImage )
		transition.cancel( self )
		if state == true then
			transition.fadeIn( colourImage, { time = time } )
		else
			transition.fadeOut( colourImage, { time = time } )
		end

	end

	function result:tap()
		if self.isEnabled == false then

			Runtime:dispatchEvent( { name = 'soundEvent', key = 'Navigate_09' } )
			
		else

			Runtime:dispatchEvent( { name = 'soundEvent', key = 'Bleep_04' } )
			Runtime:dispatchEvent( { name = 'undoButtonTapped' } )
		end
	end
	result:addEventListener( 'tap', result )

	return result

end

return UndoButtonWidget