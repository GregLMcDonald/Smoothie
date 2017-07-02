local Ingredients = {}


function Ingredients.getList()


	local ingredientList = {}
	local ingredientListKeys = {}


	local ingredientDatabaseFilename = 'ingredients.db'
	local sqlite3 = require( "sqlite3" )
	local path = system.pathForFile( ingredientDatabaseFilename )
	local db = sqlite3.open( path ) 


	if db then

		-- RETRIEVE INGREDIENTS

		local sql = "SELECT * FROM ingredients;"
		for row in db:nrows( sql ) do

			local ingredient = {}

			local key
			local colour = {}
			for k,v in pairs(row) do
				if 'name' == k then

					key = v
					ingredient.name = v

				elseif 'red' == k or 'green' == k or 'blue' == k then

					colour[ k ] = v / 255 or 1

				elseif 'is' == string.sub( k, 1, 2 ) then

					ingredient[ k ] = true
					if 0 == v then
						ingredient[ k ] = false
					end


				else
					ingredient[ k ] = v
				end

			end

			ingredient.colour = { colour.red, colour.green, colour.blue }
			ingredient.imageFilename = 'image/'..key..'.png'



			ingredientList[ key ] = ingredient
		end


		sql = 'SELECT * FROM lang_en;'
		for row in db:nrows( sql ) do
			local ingredient = ingredientList[ row.name ]
			if ingredient then

				local strings = {}
				strings.sampleForm = row.sampleForm or row.name
				strings.iLikeForm = row.iLikeForm or row.name

				ingredient[ 'lang_en' ] = strings


			end
		end

		sql = 'SELECT * FROM lang_fr;'
		for row in db:nrows( sql ) do
			local ingredient = ingredientList[ row.name ]
			if ingredient then

				local strings = {}
				strings.sampleForm = row.sampleForm or row.name
				strings.iLikeForm = row.iLikeForm or row.name

				ingredient[ 'lang_fr' ] = strings


			end
		end

		for i=1,#ingredientList do
			local ingredient = ingredientList[ i ]
			if ingredient then
				ingredient.isUnlocked = false
			end
		end

		local status = db:close()

	end

	local ingredientListRankedKeys = {}
	local ingredientListUnrankedKeys = {}
	for k,v in pairs(ingredientList) do
		local ingredient = v
		if nil ~= ingredient.rank then
			table.insert( ingredientListRankedKeys, { key = k, rank = ingredient.rank } )
		else 
			table.insert( ingredientListUnrankedKeys, k)
		end
	end
	table.sort( ingredientListRankedKeys, function(a,b) return a.rank < b.rank end )

	for i, v in ipairs( ingredientListRankedKeys ) do
		table.insert( ingredientListKeys, v.key )
	end
	for i=1, #ingredientListUnrankedKeys do
		table.insert( ingredientListKeys, ingredientListUnrankedKeys[ i ] )
	end


	return ingredientList, ingredientListKeys

end

return Ingredients