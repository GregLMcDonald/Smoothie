local IngredientDisplayObject = {}

function IngredientDisplayObject.new( ingredient, options )

	assert( ingredient , "ingregient cannot be nil in IngredientDisplayObject.new" )

	local options = options or {}

	local displayObject = display.newGroup( )

	displayObject.ingredient = {}

	for k,v in pairs(ingredient) do
		displayObject.ingredient[ k ] = v
	end
		
	local image
	if ingredient.imageFilename then
		image = display.newImageRect(  ingredient.imageFilename, 50, 50  )	
	end

	if image then
		displayObject:insert( image )
	else

		local circle = display.newCircle( 0, 0, 25 )
		local colour = options.colour or { 0 }
		circle:setFillColor( unpack( colour ) )
		circle:setStrokeColor( 1 )
		circle.strokeWidth = 1

		displayObject:insert( circle )

		if ingredient.name and string.len( ingredient.name ) >= 4 then
			local firstLetterOfName = string.upper( string.sub( ingredient.name, 1, 4 ) )
			local letter = display.newText( {
				text = firstLetterOfName,
				fontSize = 10,
			} )
			letter:setFillColor( 1 )
			displayObject:insert( letter )
		end

	end

	

	return displayObject

	
end

return IngredientDisplayObject
