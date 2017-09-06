local Dummy = {}


local width = 160
local height = 160

function Dummy.new( options )

	local result = require( '_Appliance.Appliance' ).new(options )
	result.type = 'dummy'

	 local myText = require '_Assets.Text'
    result.actionPresent = myText.forKey( result.type..'ActionPresent' )
    result.actionPast = myText.forKey( result.type..'ActionPast' )


	local rectangle = display.newRect( result, 0, 0, width, height )
	rectangle:setFillColor( 0.7 )

	result:completeInitialization()

	return result

end


return Dummy