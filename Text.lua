local Text = {}

local defaultLang = require( 'Language' ).getPreference()


local strings = {}

strings[ 'lang_en' ] =
{
	bestScore = 'Best Rating',
	patience = 'Patience',
	blenderActionPresent = 'blend',
	blenderActionPast = 'blended',
	dummyActionPresent = 'dummify',
	dummyActionPast = 'dummified',
}

strings[ 'lang_fr' ] =
{
	bestScore = 'Meilleure Note',
	patience = 'Patience',
	blenderActionPresent = 'mixer',
	blenderActionPast = 'mixé',
	dummyActionPresent = 'stupidifier',
	dummyActionPast = 'stupidifié',
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
