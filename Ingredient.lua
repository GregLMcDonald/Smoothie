local Ingredient = {}

function Ingredient.new( options )
	print("Ingredient.new")

	local options = options or {}

	local ingredient = display.newGroup( )
	ingredient.name = options.name or ''
	ingredient.costPerUnit = options.costPerUnit or 0


	if options.image then

		local image = display.newImage(  options.image  )
		ingredient:insert( image )

	else

		local circle = display.newCircle( 0, 0, 25 )
		local colour = options.colour or { 0 }
		circle:setFillColor( unpack( colour ) )

		ingredient:insert( circle )

		if ingredient.name and string.len( ingredient.name ) > 0 then
			local firstLetterOfName = string.upper( string.sub( ingredient.name, 1, 1 ) )
			local letter = display.newText( {
				text = firstLetterOfName,
				fontSize = 30,
			} )
			letter:setFillColor( 1 )
			ingredient:insert( letter )
		end

	end

	

	return ingredient

	
end

return Ingredient
