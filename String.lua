local String = {}



local defaultLang = require( 'Language' ).getPreference()


local strings = {}

strings[ 'lang_en' ] =
{
	bestRating = 'Best Rating',
	patience = 'Patience',
}

strings[ 'lang_fr' ] =
{
	bestRating = 'Meilleure Note',
	patience = 'Patience',
}



function String.forKey( key, lang )
	
	local _lang = lang
	if nil == _lang then
		_lang = defaultLang
	end

	local result

	local _strings = strings.lang

	if _strings then
		result = _strings[ key ]
	end

	if nil == result then
		result = ''
	end

	return result

end


return String
