local Press = {}

local pressWidth = 160
local pressHeight = 160

local imageDir = '__image/appliances/'

function Press.new()

    local result = require( '_Appliance.Appliance' ).new()
    result.type = 'press'

    local myText = require '_Assets.Text'
    result.actionPresent = myText.forKey( result.type..'ActionPresent' )
    result.actionPast = myText.forKey( result.type..'ActionPast' )

    

    

    result.imageFilename = imageDir..'press.png'

    local pressImage = display.newImageRect( imageDir..'press.png', pressWidth, pressHeight )
    result:insert( pressImage )

    --[[
    result.overImage = display.newImageRect( imageDir..'mixer_darker_container.png', pressWidth, pressHeight)
    result:insert( result.overImage )
    result.overImage.alpha = 0

    for i = 1, 5 do
        local fillingName = imageDir..'mixer_fill_max5_'..tostring(i)..'.png'
        local filling = display.newImageRect( fillingName, pressWidth, pressHeight )
        filling.alpha = 0
        result:insert( filling )
        table.insert( result.fillingObjects, filling )
    end

    
    ]]

    function result:processContents( completionHandler )

        local soundKey = 'process_Compress'
        local sound = require( '_Assets.Sound' )
        local duration = sound.getDuration( soundKey )
        Runtime:dispatchEvent( { name = 'soundEvent', key = soundKey } )

        --print("WARNING: DEBUG blend time set to 0")
        --duration = 0


        if completionHandler and 'function' == type(completionHandler) then            
            timer.performWithDelay( duration + 100, completionHandler )
        end
     
    end

    return result
    
end


return Press