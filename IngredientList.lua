local ingredientList = {}

local defaultImageFilename = 'image/water.png'


ingredientList.orderedKeys = {
	'apple',
	'avocado',
	'carrot',
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
	carrot = 'carotte'
}

ingredientNames.en = {
	almond_milk = 'almond milk',
}

ingredientNames.default = ingredientNames.en


ingredientColours = {
	apple = { 255/255, 255/255, 225/255 },
	avocado = { 249/255, 234/255, 128/255 },
	lemon = { 252/255, 255/255, 0/255 },
	carrot = { 237/255, 143/255, 32/255 },
	TACO = { 128/255, 128/255, 128/255 },
	banana = { 249/255, 226/255, 128/255 },
	blueberries = { 50/255, 101/255, 214/255 },
	raspberry = { 198/255, 42/255, 106/255 },
	strawberry = { 226/255, 47/255, 55/255 },
	broccoli = { 67/255, 107/255, 28/255 },
	cabbage = { 164/255, 232/255, 105/255 },
	chili = { 209/255, 56/255, 52/255 },
	cucumber = { 216/255, 255/255, 183/255 },
	garlic = { 230/255, 230/255, 230/255 },
	grapes = { 111/255, 88/255, 168/255 },
	onion = { 233/255, 211/255, 234/255 },
	peach = { 251/255, 212/255, 144/255 },
	pear = { 215/255, 204/255, 86/255 },
	peas = { 136/255, 192/255, 87/255 },
	pickles = { 67/255, 107/255, 28/255 },
	tomato = { 209/255, 56/255, 52/255 },
}


local lang = require( 'Language' ).getPreference()

for i = 1, #ingredientList.orderedKeys do

	local key = ingredientList.orderedKeys[ i ]

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
	
	local imageFilename = 'image/'..key..'.png'

	local ingredient = {
		name = name,
		imageFilename = imageFilename,
		colour = ingredientColours[ key ],
		isUnlocked = false,
	}

	ingredientList[ key ] = ingredient


end

return ingredientList