local Text = {}

local defaultLang = require( 'Language' ).getPreference()


local strings = {}

strings[ 'lang_en' ] =
{
	bestScore = 'Best Rating',
	patience = 'Patience',
}

strings[ 'lang_fr' ] =
{
	bestScore = 'Meilleure Note',
	patience = 'Patience',
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
