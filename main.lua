-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

local sound = require( 'Sound' )
sound:init()


local composer = require "composer"
--composer.gotoScene( "scene_Play" )
composer.gotoScene( 'scene_Title' )