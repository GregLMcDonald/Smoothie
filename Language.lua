local Language = {}


function Language.getPreference()

	local lang = system.getPreference( 'locale', 'language' )
	
	if lang then
	
		if lang == 'English' then
			lang = 'en'
		elseif lang == 'French' then
			lang = 'fr'
		end
	
	else
	
		lang = 'default'
	
	end

	return lang

end




return Language