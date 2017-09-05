local Ingredients = {}

local Ingredient = require( '_Culinary.Ingredient' )


function Ingredients.getList( isEarned, isUnlocked )


	local ingredientList = {}
	local ingredientListKeys = {}


	local ingredientDatabaseFilename = '_Culinary/ingredients.db'
	local sqlite3 = require( "sqlite3" )
	local path = system.pathForFile( ingredientDatabaseFilename, system.ResourceDirectory )
	local db = sqlite3.open( path ) 


	if db then

		-- RETRIEVE INGREDIENTS

		local sql = "SELECT * FROM ingredients;"
		for row in db:nrows( sql ) do

			local ingredient = Ingredient.new()

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
			ingredient.imageFilename = '__image/ingredients/'..key..'.png'



			ingredientList[ key ] = ingredient
		end


		sql = 'SELECT * FROM lang_en;'
		for row in db:nrows( sql ) do
			local ingredient = ingredientList[ row.name ]
			if ingredient then

				local strings = {}
				strings.sampleForm = {}
				strings.sampleForm.text = row.sampleForm or row.name
				strings.sampleForm.plural = false
				if row.samplePlural and 1 == row.samplePlural then
					strings.sampleForm.plural = true
				end
				strings.sampleForm.gender = row.sampleGender or 'M'

				strings.iLikeForm = {}
				strings.iLikeForm.text = row.iLikeForm or row.name
				strings.iLikeForm.plural = false
				if row.iLikePlural and 1 == row.iLikePlural then
					strings.iLikeForm.plural = true
				end
				strings.iLikeForm.gender = row.iLikeGender or 'M'


				ingredient[ 'lang_en' ] = strings


			end
		end

		sql = 'SELECT * FROM lang_fr;'
		for row in db:nrows( sql ) do
			local ingredient = ingredientList[ row.name ]
			if ingredient then

				local strings = {}
				strings.sampleForm = {}
				strings.sampleForm.text = row.sampleForm or row.name
				strings.sampleForm.plural = false
				if row.samplePlural and 1 == row.samplePlural then
					strings.sampleForm.plural = true
				end
				strings.sampleForm.gender = row.sampleGender or 'M'

				strings.iLikeForm = {}
				strings.iLikeForm.text = row.iLikeForm or row.name
				strings.iLikeForm.plural = false
				if row.iLikePlural and 1 == row.iLikePlural then
					strings.iLikeForm.plural = true
				end
				strings.iLikeForm.gender = row.iLikeGender or 'M'

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

	--Cull ingredients that are locked or unearned
	if isEarned or isUnlocked then
		local goodKeys = {}
		for i=1,#ingredientListKeys do
			local key = ingredientListKeys[ i ]
			if false == isEarned[ key ] or false == isUnlocked[ key ] then
				ingredientList[ key ] = nil
			else
				goodKeys[ #goodKeys + 1 ] = key
			end
		end
		ingredientListKeys = goodKeys
	end


	return ingredientList, ingredientListKeys

end

function Ingredients.copyIngredient( ingredient )
	local copy = {}
	for k,v in pairs(ingredient) do
		copy[ k ] = v
	end
	return copy
end

return Ingredients