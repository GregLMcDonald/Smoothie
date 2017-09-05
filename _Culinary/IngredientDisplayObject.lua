local IngredientDisplayObject = {}

function IngredientDisplayObject.new( ingredient, options )

	assert( ingredient , "ingregient cannot be nil in IngredientDisplayObject.new" )

	local options = options or {}
	local isEarned = options.isEarned or false

	local displayObject = display.newGroup( )

	displayObject.ingredient = {}

	-- copy table so it won't be accidentally changed downstream
	for k,v in pairs(ingredient) do
		displayObject.ingredient[ k ] = v
	end
		
	local image
	if displayObject.ingredient.imageFilename then
		image = display.newImageRect(  displayObject.ingredient.imageFilename, 50, 50  )

	end

	if image then
		displayObject.image = image
		
		displayObject:insert( image )
	else

		local circle = display.newCircle( 0, 0, 25 )
		local colour = options.colour or { 0 }
		circle:setFillColor( unpack( colour ) )
		circle:setStrokeColor( 1 )
		circle.strokeWidth = 1

		displayObject:insert( circle )

		if displayObject.ingredient.name and string.len( displayObject.ingredient.name ) >= 4 then
			local firstLetterOfName = string.upper( string.sub( displayObject.ingredient.name, 1, 4 ) )
			local letter = display.newText( {
				text = firstLetterOfName,
				fontSize = 10,
				font = 'HAMBH___.ttf',
			} )
			letter:setFillColor( 1 )
			displayObject:insert( letter )
		end

	end

	function displayObject:setEarned( state )
		displayObject.isEarned = state
		if false == state then 
			if displayObject.image then
				displayObject.image.fill.effect = "filter.grayscale"
			end
			displayObject.alpha = 0.3
		else
			if displayObject.image then
				displayObject.image.fill.effect = nil
				
			end
			displayObject.alpha = 1
		end
	end

	displayObject:setEarned( isEarned )
	

	return displayObject

	
end

return IngredientDisplayObject
