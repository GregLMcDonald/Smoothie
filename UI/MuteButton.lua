local MuteButton = {}

function MuteButton.new()

	local result = display.newGroup( )


	local onImage = display.newImageRect( 'image/ui/muteOn2.png', 40, 40)
	result:insert( onImage )
	result.onImage = onImage
	local offImage = display.newImageRect( 'image/ui/muteOff2.png', 40, 40)
	result:insert( offImage )
	result.offImage = offImage

	function result:setMuted( state, time )

		self.isMuted = state
		local time = time or 100

		transition.cancel( self.onImage )


		if state == false then
			audio.setVolume( 1 )
			transition.fadeIn( self.offImage, { time = time } )
		else
			audio.setVolume( 0 )
			transition.fadeOut( self.offImage, { time = time })
		end
	end
	result:setMuted( false, 0 )

	return result

end

return MuteButton
