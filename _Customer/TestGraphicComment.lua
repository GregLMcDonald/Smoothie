local TestGraphicComment = {}

function TestGraphicComment.run()

	local Availability = require '_Assets.Availability'
	local earnedAvailability = Availability.getEarnedAvailabilityCopy()
	local unlockedAvailability = Availability.getUnlockedAvailabilityCopy()

	local Ingredients = require '_Culinary.Ingredients'
	local ingredientList
	local ingredientListKeys
	ingredientList, ingredientListKeys = Ingredients.getList( earnedAvailability, unlockedAvailability )

	local Customer = require( '_Customer.Customer' )
	local thisCustomer = Customer.new( ingredientList )


	local bg = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	bg:setFillColor( 1 )
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	local GraphicComment = require('_Customer.GraphicComment')

	print("===============================================================")
	print("TestGraphicComment: running GraphicComment.testImageFilenames() ")
	
	GraphicComment.testImageFilenames( true )

	--local commentString = "{me}{math:equals}{ingredient:raspberry}{punctuation:question}{newline}{emoticon:kissWink}"
	
	--local commentString = [[
	--{me}{math:equals}{ingredient:raspberry}{punctuation:question}{newline}\z
	--{emoticon:kissWink}
	--]]


	print("===============================================================")
	print("TestGraphicComment: testing comment strings")

	local commentString = [[
	{me}{math:equals}{animal:gorilla}{punctuation:question}{newline}\z
	{ingredient:carrot}{math:isGreaterThan}{ingredient:strawberry}{newline}\z
	{ingredient:carrot}{ingredient:carrot}{ingredient:carrot}{punctuation:ellipsis}{emoticon:devil}{newline}\z
	{ingredient:apple}{math:equals}{emoticon:vomiting}
	]]
	local comment =  GraphicComment.new( commentString , { customer = thisCustomer, maxWidth = display.contentWidth } )
	print('comment.height',comment.height,'comment.width',comment.width)

	comment.y = display.contentCenterY - 0.5 * comment.height
	comment.x = display.contentCenterX  - 0.5 * comment.width

	local frame = display.newRect( 0, 0, comment.width, comment.height)
	frame:setStrokeColor( 0 )
	frame:setFillColor( 1,1,1,0 )
	frame.strokeWidth = 1
	frame.x = comment.x + 0.5 * comment.width
	frame.y = comment.y + 0.5 * comment.height

	local dot = display.newCircle( 0,0,2)
	dot:setFillColor( 1,1,0 )
	dot.x = comment.x
	dot.y = comment.y




end


return TestGraphicComment