local Dummy = {}


local width = 200
local height = 200

function Dummy.new()

	local result = require( 'Appliance.Appliance' ).new()
	result.action = 'dummy action'


	local rectangle = display.newRect( result, 0, 0, width, height )
	rectangle:setFillColor( 0.7 )

	return result

end


return Dummy