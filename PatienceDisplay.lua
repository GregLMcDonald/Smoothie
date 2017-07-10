local PatienceDisplay = {}

function PatienceDisplay.new()

	local result = display.newGroup()

	local patienceBg = display.newRect( 0, 0, 100, 15 )
	patienceBg.anchorX = 0
	patienceBg:setFillColor( 0.7 )
	result:insert( patienceBg )

	local patienceBar = display.newRect( 0, 0, 100, 15 )
	patienceBar.anchorX = 0
	patienceBar:setFillColor( 0, .5, 0 )
	result:insert( patienceBar )

	function result:setValue( value )
		if value > 0.99 then value = 0.99 end
		if value < 0 then value = 0 end

		transition.cancel( patienceBar )

		
		transition.to( patienceBar, { xScale = value, time = 250 })
	end

	return result
end

return PatienceDisplay