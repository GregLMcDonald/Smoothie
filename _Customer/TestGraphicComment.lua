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


	local GraphicComment = require('_Customer.GraphicComment')
	GraphicComment.new( "{me}{ingredient:apple}{math:equals}{emoticon:devil}{emoticon:poop}{punctuation:exclamation}", { customer = thisCustomer } )

end


return TestGraphicComment