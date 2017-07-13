local Preferences = {}



local ingredients, ingredientKeys = require( '_Culinary.Ingredients' ).getList()

local applianceKeys = {
	'appliance1',
	'appliance2',
	'appliance3',
	'appliance4',
	'appliance5',
}

local preferences = {}
local preferencesLoaded = false


function Preferences.load()
	
	for i=1, #applianceKeys do
		local key = applianceKeys[ i ]
		local value = system.getPreference( 'app', key, 'boolean' )
		if value then
			preferences[ key ] = value
		else
			preferences[ key ] = true
		end
	end

	for i=1,#ingredientKeys do
		local key = ingredientKeys[ i ]
		local value = system.getPreference( 'app', key, 'boolean'  )
		if nil ~= value then
			preferences[ key ] = value
		else
			if i > 5 then 
				preferences[ key ] = true
			else
				preferences[ key ] = false
			end
		end
	end

	preferencesLoaded = true

end

function Preferences.getCopy()

	if preferencesLoaded == false then
		Preferences.load()
	end

	local copy = {}
	for k,v in pairs( preferences ) do
		copy[ k ] = v
	end

	return copy
		
end

function Preferences.set( key, value )
	preferences[ key ] = value
end
function Preferences.get( key )
	return preferences[ key ]
end

function Preferences.save()
	system.setPreferences( 'app', preferences )
end

return Preferences