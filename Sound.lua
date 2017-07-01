
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
    'process_Blend',
    'process_Compress',
    'process_Electrical',
    'process_Foam',
    'process_Squirt',
}

local handles = {}

for i=1,#bases do
    local base = bases[ i ]
    local selectSoundFilename = filenameForBase( base )
    if selectSoundFilename then
        print("loading "..selectSoundFilename)
	   handles[ base ] = audio.loadSound( selectSoundFilename )
    end
end

local function playSound( soundEvent )
    if handles[ soundEvent.key ] then
        audio.play( handles[ soundEvent.key ] )
    end
end
Runtime:addEventListener( 'soundEvent', playSound )
