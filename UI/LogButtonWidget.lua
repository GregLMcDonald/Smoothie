local LogButtonWidget = {}

function LogButtonWidget.new()
	
	local result = display.newGroup()

	local grayImage = display.newImageRect( 'image/ui/bookGray.png', 40, 40 )
	local colourImage = display.newImageRect( 'image/ui/book.png', 40, 40 )


	result:insert( grayImage )
	result:insert( colourImage )
	
	result.isEnabled = true

	function result:setEnabled( state )
		self.isEnabled = state
	
		transition.cancel( colourImage )
		if state == true then
			transition.fadeIn( colourImage, { time = 150 } )
		else
			transition.fadeOut( colourImage, { time = 250 } )
		end

	end

	function result:tap()
		if self.isEnabled == false then return false end

		Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )
		Runtime:dispatchEvent( { name = 'logButtonTapped' } )
	end
	result:addEventListener( 'tap', result )

	return result

end

return LogButtonWidget