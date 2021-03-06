local LogButtonWidget = {}

function LogButtonWidget.new()
	
	local result = display.newGroup()

	local grayImage = display.newImageRect( '__image/ui/bookGray.png', 40, 40 )
	local colourImage = display.newImageRect( '__image/ui/book.png', 40, 40 )


	result:insert( grayImage )
	result:insert( colourImage )
	
	result.isEnabled = true

	function result:setEnabled( state, time )
		self.isEnabled = state
	
		local time = time or 150
		transition.cancel( colourImage )
		transition.cancel( self )
		if state == true then
			transition.to( self, { xScale = 0.7, yScale = 0.7, time = 0.1 * time } )
			transition.to( self, { xScale = 1, yScale = 1, delay = 0.1 * time, time = 5 * time, transition = easing.outElastic })
			transition.fadeIn( colourImage, { time = time } )
		else
			transition.fadeOut( colourImage, { time = time } )
		end

	end

	function result:tap()
		if self.isEnabled == false then

			Runtime:dispatchEvent( { name = 'soundEvent', key = 'Navigate_09' } )
			
		else

			--Runtime:dispatchEvent( { name = 'soundEvent', key = 'select' } )
			Runtime:dispatchEvent( { name = 'logButtonTapped' } )
		end
	end
	result:addEventListener( 'tap', result )

	return result

end

return LogButtonWidget