local Text = {}

local defaultLang = require( 'Language' ).getPreference()


local englishCredits = 'Snack Lab\n(c)2017 Greg McDonald\n\nConcept: Thomas McDonald\n\nProgramming: Greg McDonald\n\nWriting: Thomas and Greg McDonald\n\nAudio:\n\nSounds by Frank Serafine, SFX Bible, Airborne Sound and Blastwave FX from Soundsnap. Other sounds from the UI SFX collection by Stuart Duffield (available on Corona Marketplace).\n\nGraphics:\n\nIcons designed by Madebyoliver and Freepix from Flaticon.'
local frenchCredits = 'Snack Lab\n(c)2017 Greg McDonald\n\nConcept: Thomas McDonald\n\nProgramation: Greg McDonald\n\nRédaction: Thomas et Greg McDonald\n\n\n\nAudio:\n\nEnregistrements de Frank Serafine, SFX Bible, Airborne Sound et Blastwave FX disponibles sur Soundsnap. D\'autres enregistrements ont été tirés de la collection UI SFX de Stuart Duffield (disponible au Corona Marketplace).\n\nGraphism:\n\nIcônes créées par Madebyoliver et Freepix de Flaticon.'


local strings = {}

strings[ 'lang_en' ] =
{
	bestScore = 'Best Rating',
	patience = 'Patience',
	blenderActionPresent = 'blend',
	blenderActionPast = 'blended',
	dummyActionPresent = 'dummify',
	dummyActionPast = 'dummified',
	grinderActionPresent = 'grind',
	grinderActionPast = 'ground',
	pressActionPresent = 'squeeze',
	pressActionPast = 'compressed',
	credits = englishCredits,
}

strings[ 'lang_fr' ] =
{
	bestScore = 'Meilleure Note',
	patience = 'Patience',
	blenderActionPresent = 'mixer',
	blenderActionPast = 'mixé',
	dummyActionPresent = 'stupidifier',
	dummyActionPast = 'stupidifié',
	grinderActionPresent = 'moudre',
	grinderActionPast = 'moulu',
	pressActionPresent = 'compresser',
	pressActionPast = 'compressé',
	credits = frenchCredits,
}



function Text.forKey( key, lang )
	
	local _lang = lang
	if nil == _lang then
		_lang = defaultLang
	end

	local result

	local myStrings = strings[ _lang ]
	
	if myStrings then
		result = myStrings[ key ]
	end

	if nil == result then
		result = ''
	end

	return result

end


return Text
