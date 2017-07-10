-- Customer.lua

-------------------------------------------------------------------------------
--
--  AVATAR
--
-------------------------------------------------------------------------------
local avatarImageDirectory = 'image/customers/'
local nBoys = 23
local nGirls = 27

local function getAvatarImageFilename()

	local result

	-- Randomly select boy or girl
	local flip = math.random()
	local gender
	if flip < 0.5 then
		gender = 'boy'
	else
		gender = 'girl'
	end
	local number 
	if 'boy' == gender then
		number = math.random( nBoys )
	else
		number = math.random( nGirls )
	end
	result = avatarImageDirectory..gender..'-'..tostring(number)..'.png'

	return result
end



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

local function getIngredientsAtExtremumOfPreferencesInRecipe( recipe, preferences, favorite )

	if #recipe.ingredients < 1 then return nil end

	local compare
	if nil == favorite or true == favorite then
		compare = function( a, b ) return a > b end
	else
		compare = function( a, b ) return a <= b end
	end

	local ingredient = recipe.ingredients[ 1 ]
	local preferenceCoefficientExtremum = preferences[ ingredient.name ]
	local ingredientsAtExtremum = { ingredient }
	
	if #recipe.ingredients > 1 then
		for i = 2,#recipe.ingredients do
			local ingredient = recipe.ingredients[ i ]
			local preferenceCoefficient = preferences[ ingredient.name ]
			if compare( preferenceCoefficient, preferenceCoefficientExtremum ) then
				preferenceCoefficientExtremum = preferenceCoefficient
				ingredientsAtExtremum = { ingredient }
			elseif preferenceCoefficient == preferenceCoefficientExtremum then
				ingredientsAtExtremum[ #ingredientsAtExtremum + 1 ] = ingredient
			end
		end
	end

	return ingredientsAtExtremum, preferenceCoefficientExtremum
end

local function getIngredientsPreferredOverThoseInRecipe( recipe, preferences )
	
	-- Copy preferences table
	local copyOfPreferences = {}
	for k,v in pairs(preference) do
		copyOfPreferences[k] = v
	end

	-- Remove ingredients used in recipe from the copy
	for i = 1, #recipe.ingredients do
		local ingredient = recipe.ingredients[ i ]
		copyOfPreferences[ ingredient.name ] = nil
	end

	-- For each ingredient used in recipe, identify any unused ingredients that would
	-- be preferable
	local preferableIngredientsForTheRecipe = {}

	for i = 1, #recipe.ingredients do

		local ingredient = recipe.ingredients[ i ]
		
		if nil == preferableIngredientsForTheRecipe[ ingredient.name ] then
		
			local preferableIngredients = {}
			for ingredientName, preferenceCoefficient in pairs(_preferences) do
				if preferences[ ingredient.name ] < preferenceCoefficient then
					table.insert( preferableIngredients, ingredientName )
				end
				preferableIngredientsForTheRecipe[ ingredient.name ] = preferableIngredients
			end
		end
	end
end


local Customer = {}

function Customer.new( ingredients, options )

	local result = {}

	result.avatarImageFilename = getAvatarImageFilename()

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

		for k,v in pairs(recipe.ingredients) do
			print(k,v.name)
		end


		local fav, coeff = getIngredientsAtExtremumOfPreferencesInRecipe( recipe, self.preferences, true )
		if fav then
			print("FAV ",fav[1].name,coeff)
		end
		fav,coeff = getIngredientsAtExtremumOfPreferencesInRecipe( recipe, self.preferences, false )
		if fav then
			print("LEAST FAV ",fav[1].name, coeff)
		end

		local Rating = require 'Rating'
		
		local myRating = Rating.minValue

		if #recipe.ingredients > 0 and false == recipe:hasDealBreakers( self.dealBreakerProperties ) then
		
			local averagePreferrenceCoefficient = self:computeAveragePreferrenceCoefficientForRecipe( recipe )	
			myRating = 5 + averagePreferrenceCoefficient

			if recipe:lacksVariety() then myRating = myRating - Rating.penalty.forLackingVariety end

		end


		if myRating < Rating.minValue then myRating = Rating.minValue end
		if myRating > Rating.maxValue then myRating = Rating.maxValue end

		return myRating

	end


	function result:respondToRecipe( recipe )
		local response = ""

		return response
	end


	return result

end


return Customer