local IngredientList = {}

local defaultImageFilename = 'images/water.png'


IngredientList.orderedKeys = {
	'apple',
	'avocado',
	'lemon',
	'TACO',
	'banana',
	'blueberries',
	'raspberry',
	'strawberry',
	'broccoli',
	'cabbage',
	'chili',
	'cucumber',
	'garlic',
	'grapes',
	'onion',
	'peach',
	'pear',
	'peas',
	'pickles',
	'tomato',
}


local ingredientNames = {}

ingredientNames.fr = {
	apple = 'pomme',
	avocado = 'avocat',
	lemon = 'citron',
	TACO = 'TACO',
	banana = 'banane',
	blueberries = 'bleuets',
	raspberry = 'framboise',
	strawberry = 'fraise',
	broccoli = 'broccoli',
	cabbage = 'chou',
	chili = 'chili',
	cucumber = 'concombre',
	garlic = 'ail',
	grapes = 'raisins',
	onion = 'oignon',
	peach = 'pêche',
	pear = 'poire',
	peas = 'pois',
	pickles = 'cornichons',
	tomato = 'tomate',
}

ingredientNames.en = {
	almond_milk = 'almond milk',
}

ingredientNames.default = ingredientNames.en


local lang = require( 'Language' ).getPreference()

for i = 1, #IngredientList.orderedKeys do

	local key = IngredientList.orderedKeys[ i ]

	local name
	if ingredientNames[ lang ] then
			name = ingredientNames[ lang ][ key ]
	end

	if nil == name then	
		if ingredientNames.default[ key ] then
			name = ingredientNames.default[ key ]
		else
			name = key
		end
	end
	
	local imageFilename = 'images/'..key..'.png'
	local path = system.pathForFile( imageFilename )
	if nil == path then
		imageFilename = nil
	end



	local ingredient = {
		name = name,
		imageFilename = imageFilename,
	}

	IngredientList[ key ] = ingredient


end

return IngredientList