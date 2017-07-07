-- Customer.lua


-------------------------------------------------------------------------------
--
--  PREFERENCE HELPER METHODS
--
-------------------------------------------------------------------------------
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


-------------------------------------------------------------------------------
--
--  METHODS FOR IDENTIFYING 
--
-------------------------------------------------------------------------------
local function getLeastFavoriteIngredientsInRecipe( recipe, preferences )

	if #recipe.ingredients < 1 then return nil end

	local ingredient = recipe.ingredients[ 1 ]
	local lowestPreferenceCoefficient = preferences[ ingredient.name ]
	local leastFavoriteIngredientsInRecipe = { ingredient }
	
	if #recipe.ingredients > 1 then
		for i = 2,#recipe.ingredients do
			local ingredient = recipe.ingredients[ i ]
			local preferenceCoefficient = preferences[ ingredient.name ]
			if preferenceCoefficient < lowestPreferenceCoefficient then
				lowestPreferenceCoefficient = preferenceCoefficient
				leastFavoriteIngredientsInRecipe = { ingredient }
			elseif preferenceCoefficient == lowestPreferenceCoefficient then
				leastFavoriteIngredientsInRecipe[ #leastFavoriteIngredientsInRecipe + 1 ] = ingredient
			end
		end
	end

	return leastFavoriteIngredientsInRecipe, lowestPreferenceCoefficient
end

local function getIngredientsPreferredOverThoseInRecipe( recipe, preferences )

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


	function result:computeAveragePreferrenceCoefficientForRecipe( recipe )
		local averagePreferrenceCoefficient = 0
		
		if 0 == #recipe.ingredients then return averagePreferrenceCoefficient end

		local sumOfPreferrenceCoefficientsForIngredients = 0
		for i = 1, #recipe.ingredients do
			local ingredient = recipe.ingredients[ i ]
			local preferrenceCoefficient = self.preferences[ ingredient.name ]
			sumOfPreferrenceCoefficientsForIngredients = sumOfPreferrenceCoefficientsForIngredients + preferrenceCoefficient
		end

		averagePreferrenceCoefficient = sumOfPreferrenceCoefficientsForIngredients / #recipe.ingredients
		
		return averagePreferrenceCoefficient
	end


	function result:rateRecipe( recipe )

		local rating = 0
		local Rating = require 'Rating'

		if #recipe.ingredients > 0 and false == recipe:hasDealBreakers( self.dealBreakerProperties ) then
		
			local averagePreferrenceCoefficient = self:computeAveragePreferrenceCoefficientForRecipe( recipe )	
			rating = 5 + averagePreferrenceCoefficient

			if recipe:lacksVariety() then rating = rating + Rating.penalties.lacksVariety end

		end


		-- Ensure that result is within expected range
		if rating < Rating.minValue then rating = Rating.minValue end
		if rating > Rating.maxValue then rating = Rating.maxValue end

		return rating
	end


	function result:respondToRecipe( recipe )
		local response = ""

		return response
	end


	return result

end


return Customer