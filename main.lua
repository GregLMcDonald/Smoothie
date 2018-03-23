
-- main.lua

display.setStatusBar( display.HiddenStatusBar )


local DisplayTools = require '_Tools.DisplayTools'
--local test = DisplayTools.surroundInColour( '__image/customers/boy-1.png', {abs = 50, colour = {0,1,0} } )
--local test = DisplayTools.surroundInColour( '__image/ingredients/apple.png', {abs = 30, colour = {1,1,1} } )
local test = DisplayTools.surroundInColour( '__image/animals/monkey.png', {abs = 30, colour = { 1,0,0 } } )
test.x = display.contentCenterX
test.y = display.contentCenterY

test:setScale( 0.3 )

local rect = display.newRect( test.x, test.y, test.contentWidth, test.contentHeight )
rect:setFillColor( 1,1,1,0.3 )
rect:toBack( )

--require( '_Customer.TestGraphicComment' ).run()




--[[

local Sound = require( '_Assets.Sound' )
Sound.init()



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
	if event.type == 'applicationExit' or event.type == 'applicationSuspend' then
		Availability.save()
	end
end
Runtime:addEventListener( 'system', systemEvent )

]]