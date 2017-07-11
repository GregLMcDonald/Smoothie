local TextParameters = {}


local pixelsPerPoint = display.pixelWidth / display.contentWidth
local fontFactor = pixelsPerPoint / 2
local optimalFontSize = 24 / fontFactor

local test = display.newText( {
text = 'abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcdefghijklmnop',
font = 'Equity-Text-A-Regular.ttf',
fontSize = optimalFontSize,
} )


local maximumLineLength = math.min( test.contentWidth, 300 )

test:removeSelf( )
test = nil




function TextParameters.fontSize()
	return optimalFontSize
end
function TextParameters.maximumLineLength()
	return maximumLineLength
end

return TextParameters
