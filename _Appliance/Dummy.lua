local Dummy = {}


local width = 160
local height = 160

function Dummy.new()

	local result = require( '_Appliance.Appliance' ).new()
	result.type = 'dummy'

	 local myText = require 'Text'
    result.actionPresent = myText.forKey( result.type..'ActionPresent' )
    result.actionPast = myText.forKey( result.type..'ActionPast' )


	local rectangle = display.newRect( result, 0, 0, width, height )
	rectangle:setFillColor( 0.7 )

	return result

end


return Dummy