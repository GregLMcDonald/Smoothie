local Grinder = {}

local grinderWidth = 160
local grinderHeight = 160

local imageDir = 'image/appliances/'

function Grinder.new()

    local result = require( 'Appliance.Appliance' ).new()
    result.type = 'grinder'

    local myText = require 'Text'
    result.actionPresent = myText.forKey( result.type..'ActionPresent' )
    result.actionPast = myText.forKey( result.type..'ActionPast' )

    

    

    result.imageFilename = imageDir..'grinder.png'

    local grinderImage = display.newImageRect( imageDir..'grinder.png', grinderWidth, grinderHeight )
    result:insert( grinderImage )

    --[[
    result.overImage = display.newImageRect( imageDir..'mixer_darker_container.png', grinderWidth, grinderHeight)
    result:insert( result.overImage )
    result.overImage.alpha = 0

    for i = 1, 5 do
        local fillingName = imageDir..'mixer_fill_max5_'..tostring(i)..'.png'
        local filling = display.newImageRect( fillingName, grinderWidth, grinderHeight )
        filling.alpha = 0
        result:insert( filling )
        table.insert( result.fillingObjects, filling )
    end

    
    ]]

    function result:processContents( completionHandler )

        local soundKey = 'process_Grind'
        local sound = require( 'Sound' )
        local duration = sound:getDuration( soundKey )
        Runtime:dispatchEvent( { name = 'soundEvent', key = soundKey } )

        --print("WARNING: DEBUG blend time set to 0")
        --duration = 0


        if completionHandler and 'function' == type(completionHandler) then            
            timer.performWithDelay( duration + 100, completionHandler )
        end
     
    end

    return result
    
end


return Grinder