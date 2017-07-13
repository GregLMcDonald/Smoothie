local IngredientDisplayObject = {}

function IngredientDisplayObject.new( options )

	local options = options or {}

	local ingredient = display.newGroup( )
	ingredient.name = options.name or ''
	ingredient.costPerUnit = options.costPerUnit or 0

	options.image = '__image/apple.png'

	if options.image then

		local image = display.newImageRect(  options.image, 50, 50  )
		ingredient:insert( image )

	else

		local circle = display.newCircle( 0, 0, 25 )
		local colour = options.colour or { 0 }
		circle:setFillColor( unpack( colour ) )
		circle:setStrokeColor( 1 )
		circle.strokeWidth = 1

		ingredient:insert( circle )

		if ingredient.name and string.len( ingredient.name ) >= 4 then
			local firstLetterOfName = string.upper( string.sub( ingredient.name, 1, 4 ) )
			local letter = display.newText( {
				text = firstLetterOfName,
				fontSize = 10,
			} )
			letter:setFillColor( 1 )
			ingredient:insert( letter )
		end

	end

	

	return ingredient

	
end

return IngredientDisplayObject