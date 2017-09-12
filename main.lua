
-- main.lua

require( '_Customer.TestGraphicComment' ).run()


--[[

display.setStatusBar( display.HiddenStatusBar )

local sound = require( '_Assets.Sound' )
sound:init()



local Availability = require '_Assets.Availability'
Availability.load()
--Availability.reset()




local composer = require 'composer'

composer.loadScene( '_Scene.Play' )
composer.loadScene( '_Scene.InfoView', { infoTextKey = 'credits' } )


composer.gotoScene( '_Scene.Title' )
--composer.gotoScene( '_Scene.Play' )



local function systemEvent( event )
	print(event.type)
	if event.type == 'applicationExit' then
		Availability.save()
	end
end
Runtime:addEventListener( 'system', systemEvent )

]]