-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local sound = require( 'Sound' )
sound:init()


local ingredients, ingredientKeys = require( 'ingredients' ).getList()

local applianceKeys = {
	'appliance1',
	'appliance2',
	'appliance3',
	'appliance4',
	'appliance5',
}


local preferences = {}
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
		print('got it')
		preferences[ key ] = value
	else
		if i > 5 then 
			preferences[ key ] = true
		else
			preferences[ key ] = false
		end
	end
end



local composer = require "composer"
--composer.gotoScene( "scene_Play", { params = { preferences = preferences } } )
composer.gotoScene( 'Scene.Title' )


local function systemEvent( event )
	print(event.type)
	if event.type == 'applicationExit' then
		system.setPreferences( 'app', preferences )
	end
end
Runtime:addEventListener( 'system', systemEvent )