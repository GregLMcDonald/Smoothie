-- Customer.lua


local function getKeysWithAssignedPreferenceCoefficients( keys, areLiked, options )

	-- keys: a table of strings used as keys to the ingredient table
	-- areLiked: BOOLEAN whether the coefficients should be positive (liked) or negative (disliked)
	-- options: 
	--    weight: NUMBER factor by which to multiply the pool of available points for coefficients
	--    maxCoefficient: NUMBER

	local result = {}
	if nil == keys or 0 == #keys then return result end

	local options = options or {}
	local weight = options.weight or 1
	local maxCoefficient = options.maxCoefficient or 7

	local quota  = #keys * weight

	local myKeys = {}
	for i=1,#keys do myKeys[i] = keys[i] end

	local nAssigned = 0

	while quota > 0 and nAssigned < #keys and #myKeys > 0 do

		local index = math.random( #myKeys )
		local key = myKeys[ index ]
		table.remove( myKeys, index )
		local preferenceCoefficient = math.random( maxCoefficient )
		quota = quota - preferenceCoefficient
		if areLiked then
			result[ key ] = preferenceCoefficient
		else
			result[ key ] = - preferenceCoefficient
		end
		nAssigned = nAssigned + 1
	end
	while #myKeys > 0 do
		local key = myKeys[ #myKeys ]
		myKeys[ #myKeys ] = nil
		result[ key ] = 0
	end

	return result
end
local function getPreferredLikedAndDislikedKeySets( ingredients, preferredIngredientProperties, likedFraction )
	local likedFraction = likedFraction or 0.67

	local preferred = {}
	local liked = {}
	local disliked = {}

	local availableKeys = {}
	for key, _ in pairs( ingredients ) do
		availableKeys[ #availableKeys + 1 ] = key
	end


	-- Check for Preferred status
	local unusedKeys = {}
	for keyIndex = 1, #availableKeys do
		local key = availableKeys[ keyIndex ]
		local ingredient = ingredients[ key ]
		
		local isPreferred = false
		for preferenceKey, preferenceValue in pairs( preferredIngredientProperties ) do
			if ingredient[ preferenceKey ] == preferenceValue then
				isPreferred = true
				break
			end
		end

		if true == isPreferred then
			preferred[ #preferred + 1 ] = key
		else
			unusedKeys[ #unusedKeys + 1 ] = key
		end
	end
	availableKeys = unusedKeys

	-- Split remaining keys between Liked and Disliked
	local nLiked = math.ceil( likedFraction * #availableKeys )
	local nDisliked = #availableKeys - nLiked

	-- Randomly choose nLiked keys from availableKeys
	for i = 1, nLiked do
		local keyIndex = math.random( #availableKeys )
		liked[ #liked + 1 ] = availableKeys[ keyIndex ]
		table.remove( availableKeys, keyIndex )
	end

	-- Assign remaining keys to disliked
	for i = 1, #availableKeys do
		disliked[ #disliked + 1 ] = availableKeys[ i ]
	end

	return preferred, liked, disliked
end

local function recipeContainsDealBreakers( recipe, dealBreakerProperties )
	local result = false

	local dealBreakerFound = false
	for dealBreakerKey,dealBreakerValue in pairs( dealBreakerProperties ) do
		for i = 1, #recipe.ingredients do
			local ingredient = recipe.ingredients[ i ]
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

	return result
end
local function recipeLacksVariety( recipe )

	local result = false

	local minimumNumberOfIngredientsForVariety = 3

	local distinctIngredients = {}
	for i = 1,#recipe.ingredients do
		local ingredient = recipe.ingredients[ i ]
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
	return result
end



local Customer = {}

function Customer.new( ingredients, options )

	local result = {}

	local ingredients = ingredients or {}
	local options = options or {}

	-- If an ingredient has a key set to any of these values,
	-- the rating will automatically be 0
	result.dealBreakerProperties = {
		isEdible = false,
	}

	-- If an ingredient has a key set to any of these values,
	-- it gets 
	result.preferredIngredientProperties = {
		--isFruit = true,
	}

	result.preferences = {}
	function result:assignPreferences( ingredients )

		local preferred, liked, disliked = getPreferredLikedAndDislikedKeySets( ingredients, self.preferredIngredientProperties )
		

		local maxLikedCoefficient = 4
		local likedWeight = 1
		if 0 == #preferred then
			likedWeight = 2 
			maxLikedCoefficient = 7 
		end
		


		local preferredCoefficients = getKeysWithAssignedPreferenceCoefficients( preferred, true, { weight = 2 } )
		local likedCoefficients = getKeysWithAssignedPreferenceCoefficients( liked, true, { weight = likedWeight, maxCoefficient = maxLikedCoefficient } )
		local dislikedCoefficients = getKeysWithAssignedPreferenceCoefficients( disliked, false, { weight = 2 } )
	
		for k,v in pairs( preferredCoefficients ) do
			result.preferences[ k ] = v
		end
		for k,v in pairs( likedCoefficients ) do
			result.preferences[ k ] = v
		end
		for k,v in pairs( dislikedCoefficients ) do
			result.preferences[ k ] = v
		end
	end
	result:assignPreferences( ingredients )



	function result:rateRecipe( recipe )
		local rating = 0

		if 0 == #recipe.ingredients then 
			return 0
		end

		if recipeContainsDealBreakers( recipe, self.dealBreakerProperties) then
			return 0
		end
		
		

		local sumOfPreferrenceCoefficientsForIngredients = 0
		for i = 1, #recipe.ingredients do
			local ingredient = recipe.ingredients[ i ]
			local preferrenceCoefficient = self.preferences[ ingredient.name ]
			sumOfPreferrenceCoefficientsForIngredients = sumOfPreferrenceCoefficientsForIngredients + preferrenceCoefficient
		end

		local averagePreferrenceCoefficient = sumOfPreferrenceCoefficientsForIngredients / #recipe.ingredients
		--print(sumOfPreferrenceCoefficientsForIngredients,averagePreferrenceCoefficient)
		rating = 5 + averagePreferrenceCoefficient

		if recipeLacksVariety( recipe ) then
			print( "DEBUG penalty for overly simple recipe -1 " )
			rating = rating - 1
		end



		-- Ensure that result is withing expected range
		if rating < 0 then rating = 0 end
		if rating > 10 then rating = 10 end

		return rating
	end


	function result:respondToRecipe( recipe )
		local response = ""

		return response
	end


	return result

end


return Customer