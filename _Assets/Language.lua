local Language = {}

local currentLanguage = nil


function Language.getPreference()

	local lang = system.getPreference( 'locale', 'language' )

	if lang then
	
		if lang == 'English' or lang == 'en' then
			lang = 'lang_en'
		elseif lang == 'French' or lang == 'fr' then
			lang = 'lang_fr'
		else
			lang = 'lang_en'
		end
	
	else
	
		lang = 'lang_en'
	
	end

	return 'lang_en'
	--return 'lang_fr'
	--return 'lang_jp'
	--return lang

end

function Language.getCurrentLanguage()

	if nil == currentLanguage then
		currentLanguage = Language.getPreference()
	end

	return currentLanguage
end


return Language