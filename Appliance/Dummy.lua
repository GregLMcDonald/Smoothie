local Dummy = {}


local width = 160
local height = 160

function Dummy.new()

	local result = require( 'Appliance.Appliance' ).new()
	result.action = 'dummy action'


	local rectangle = display.newRect( result, 0, 0, width, height )
	rectangle:setFillColor( 0.7 )

	return result

end


return Dummy