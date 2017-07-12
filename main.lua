
-- main.lua

display.setStatusBar( display.HiddenStatusBar )

local sound = require( 'Sound' )
sound:init()



local preferences = require 'Preferences'
preferences.load()




local composer = require 'composer'

composer.loadScene( '_Scene.Play' )
composer.loadScene( '_Scene.InfoView', { infoTextKey = 'credits' } )


composer.gotoScene( '_Scene.Title' )



local function systemEvent( event )
	print(event.type)
	if event.type == 'applicationExit' then
		preferences.save()
	end
end
Runtime:addEventListener( 'system', systemEvent )