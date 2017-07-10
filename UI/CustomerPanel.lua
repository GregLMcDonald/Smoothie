local CustomerPanel = {}

local Language = require 'Language'
local text = require 'Text'





function CustomerPanel.new( customer )

	local result = display.newGroup( )


	local bg = display.newRect( 0, 0, 320, 50 )
	if bg then
		bg:setFillColor( 0.9, 0.9, 0.9 )
		result:insert( bg )
	end




	if customer.avatarImageFilename then
		local avatar = display.newImageRect( customer.avatarImageFilename, 40, 40 )
		if avatar then
			avatar.x = -135
			avatar.y = 0
			result:insert( avatar )
		end
	end

	local _label = string.upper( text.forKey( 'patience' ) )
	local patienceLabel = display.newText({ 
		text = _label,
		fontSize = 12,
	})
	patienceLabel:setFillColor( 0 )
	patienceLabel.anchorX = 0
	patienceLabel.x = -110
	patienceLabel.y = 2 + 0.5 * patienceLabel.contentHeight
	result:insert( patienceLabel )

	
	local patienceDisplay = require( 'UI.patienceDisplay' ).new()
	patienceDisplay.x = patienceLabel.x + patienceLabel.contentWidth + 3
	patienceDisplay.y = patienceLabel.y
	result:insert( patienceDisplay )
	function result:setPatience( value )
		patienceDisplay:setValue( value )
	end

	_label = string.upper( text.forKey( 'bestScore' ) )
	local ratingLabel = display.newText({
		text = _label,
		fontSize = 12,
		})
	ratingLabel:setFillColor( 0 )
	ratingLabel.anchorX = 0
	ratingLabel.x = -110
	ratingLabel.y = -2 - 0.5 * ratingLabel.contentHeight
	result:insert( ratingLabel ) 


	local ratingDisplay = require( 'UI.RatingDisplay' ).new()
	local ratingScale = 100 / ratingDisplay.width
	ratingDisplay.xScale = ratingScale
	ratingDisplay.yScale = ratingScale
	ratingDisplay.x = ratingLabel.x + ratingLabel.contentWidth + 2	
	ratingDisplay.y = ratingLabel.y 
	result:insert( ratingDisplay )

	function result:setRating( value )
		ratingDisplay:setRating( value )
	end

	local logButton = require('UI.LogButtonWidget').new()
	logButton.x = 138
	result:insert( logButton )
	function result:setLogButtonEnabled( state )
		logButton:setEnabled( state )
	end


	return result


end


return CustomerPanel