local Recipe = {}

function Recipe.new( ingredients, applianceLite )
	local result = {}

	result.ingredients = ingredients
	result.appliance = applianceLite


	function result:hasDealBreakers( dealBreakerProperties )
		if nil ~= self.isRecipeWithDealBreakers then
			return self.isRecipeWithDealBreakers
		end

		local result = false

		local dealBreakerFound = false
		for dealBreakerKey,dealBreakerValue in pairs( dealBreakerProperties ) do
			for i = 1, #self.ingredients do
				local ingredient = self.ingredients[ i ]
				if ingredient[ dealBreakerKey ] == dealBreakerValue then
					print("DEBUG deal breaker",ingredient.name,dealBreakerKey,dealBreakerValue)
					dealBreakerFound = true
					break
				end
			end
			if dealBreakerFound == true then
				-- Only need one dealBreaker to get a 0 rating
				result = true
				break
			end
		end

		self.isRecipeWithDealBreakers = result

		return result
	end

	function result:lacksVariety()
		if nil ~= self.isRecipeWhichLacksVariety then
			return self.isRecipeWhichLacksVariety
		end

		local result = false

		local minimumNumberOfIngredientsForVariety = 3

		local distinctIngredients = {}
		for i = 1,#self.ingredients do
			local ingredient = self.ingredients[ i ]
			if nil == distinctIngredients[ ingredient.name ] then
				distinctIngredients[ ingredient.name ] = true
			end
		end
		local nDistinctIngredients = 0
		for k,v in pairs(distinctIngredients) do
			nDistinctIngredients = nDistinctIngredients + 1
		end
		if nDistinctIngredients < minimumNumberOfIngredientsForVariety then
			print( "DEBUG lacks variety: less than "..tostring(minimumNumberOfIngredientsForVariety).." ingredients" )
			result = true
		end

		self.isRecipeWhichLacksVariety = result

		return result
	end

	return result
end

return Recipe
