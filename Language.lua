local Language = {}


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

	return lang

end




return Language