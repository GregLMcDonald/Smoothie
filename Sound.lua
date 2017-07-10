local Sound = {}

function Sound.init()


    local soundFilenameSuffix = '.ogg'


    local directoryPrefix = "audio/"
    local androidSuffix = ".ogg"
    local iosSuffix = ".m4a"

    local function filenameForBase( base )

        local fn = directoryPrefix..base..androidSuffix
        if system.pathForFile( fn , system.ResourceDirectory ) ~= nil then
            return fn
        end

        fn = directoryPrefix..base..iosSuffix 
        if system.pathForFile( fn, system.ResourceDirectory ) ~= nil then
            return fn
        end

        return nil
    end

    local bases = {
        'select',
        'release',
        'alert_deviceUnlocked',
        'alert_ingredientUnlocked',
        'Alert_03',
        'Alert_08',
        'Bleep_04',
        'Maximise_08',
        'Navigate_09',
        'process_Blend',
        'process_Compress',
        'process_Electrical',
        'process_Foam',
        'process_Squirt',
    }

    Sound.handles = {}

    for i=1,#bases do
        local base = bases[ i ]
        local selectSoundFilename = filenameForBase( base )
        if selectSoundFilename then
            Sound.handles[ base ] = audio.loadSound( selectSoundFilename )
        end
    end

    local function playSound( soundEvent )
        if Sound.handles[ soundEvent.key ] then
            audio.play( Sound.handles[ soundEvent.key ] )
        end
    end
    Runtime:addEventListener( 'soundEvent', playSound )

end

function Sound:getDuration( key )
    local duration = 0
    if self.handles[ key ] then
        duration = audio.getDuration( self.handles[ key ] )
    end
    return duration
end

return Sound
