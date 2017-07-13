local Sound = {}

function Sound.init()

    audio.reserveChannels( 1 )

    local soundFilenameSuffix = '.ogg'


    local directoryPrefix = '__audio/'
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
        'Curious',
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

function Sound.getDuration( key )
    local duration = 0
    if Sound.handles[ key ] then
        duration = audio.getDuration( Sound.handles[ key ] )
    end
    return duration
end

local backgroundMusicVolume = 1
function Sound.playBackgroundMusic()
    if Sound.isPlayingBackgroundMusic ~= true then 
        if Sound.handles[ 'Curious' ] then
            audio.play( Sound.handles[ 'Curious' ], { channel = 1, onComplete = function() Sound.isPlayingBackgroundMusic = false; Sound.playBackgroundMusic() end } )
        end
        Sound.isPlayingBackgroundMusic = true
    end
end

function Sound.duckBackgroundMusic( state )
    if true == state then
        backgroundMusicVolume = .1
    else
        backgroundMusicVolume = 1
    end
    audio.setVolume( backgroundMusicVolume , {channel = 1} )
end

function Sound.stopBackgroundMusic()
    audio.stop( 1 )
    Sound.isPlayingBackgroundMusic = false
end

return Sound
