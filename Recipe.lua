local Recipe = {}

function Recipe.new( ingredients, action )
	local result = {}

	result.ingredients = ingredients
	result.action = action

	return result
end

return Recipe
