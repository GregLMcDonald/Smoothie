local CustomerPanel = {}

local Language = require 'Language'
local text = require 'Text'





function CustomerPanel.new( customer )

	local result = display.newGroup( )


	local bg = display.newRect( 0, 0, 320, 50 )
	if bg then
		--bg:setFillColor( 0.9, 0.9, 0.9 )
		bg:setFillColor( 0 )
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
		fontSize = 14,
		font = 'HAMBH___.ttf',
	})
	patienceLabel:setFillColor( 1 )
	patienceLabel.anchorX = 0
	patienceLabel.x = -110
	patienceLabel.y = 2 + 0.5 * patienceLabel.contentHeight
	result:insert( patienceLabel )

	
	local patienceDisplay = require( '_UI.PatienceDisplay' ).new()
	patienceDisplay.x = patienceLabel.x + patienceLabel.contentWidth + 3
	patienceDisplay.y = patienceLabel.y
	result:insert( patienceDisplay )
	function result:setPatience( value )
		patienceDisplay:setValue( value )
	end

	--_label = string.upper( text.forKey( 'bestScore' ) )
	_label = text.forKey( 'bestScore' )
	local ratingLabel = display.newText({
		text = _label,
		fontSize = 14,
		font = 'HAMBH___.ttf',
		})
	ratingLabel:setFillColor( 1 )
	ratingLabel.anchorX = 0
	ratingLabel.x = -110
	ratingLabel.y = -2 - 0.5 * ratingLabel.contentHeight
	result:insert( ratingLabel ) 

	result.bestRating = 0
	local ratingDisplay = require( '_UI.RatingDisplay' ).new( 0 	)
	local ratingScale = 100 / ratingDisplay.width
	ratingDisplay.xScale = ratingScale
	ratingDisplay.yScale = ratingScale
	ratingDisplay.x = ratingLabel.x + ratingLabel.contentWidth + 2	
	ratingDisplay.y = ratingLabel.y 
	result:insert( ratingDisplay )

	function result:setRating( value )
		if value > self.bestRating then 
			self.bestRating = value
			ratingDisplay:setRating( value )
		end
	end

	local logButton = require('_UI.LogButtonWidget').new()
	logButton.x = 138
	result:insert( logButton )
	if #customer.log < 1 then
		logButton:setEnabled( false, 0 )
	else
		logButton:setEnabled( true, 0 )
	end
	function result:setLogButtonEnabled( state, time )
		logButton:setEnabled( state, time )
	end


	return result


end


return CustomerPanel