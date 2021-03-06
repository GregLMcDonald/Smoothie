local Text = {}

local defaultLang = require( '_Assets.Language' ).getPreference()


local englishCredits = 'Snack Lab\n(c)2017 Greg McDonald\n\nConcept:\nThomas and Greg McDonald\n\nProgramming:\nGreg McDonald\n\nWriting:\nThomas and Greg McDonald\n\nGraphics:\nIcons designed by Madebyoliver, Freepix and Puppets from Flaticon. Additional graphics by Greg and Thomas McDonald.\n\nBackground Music:\n“Curious” by Nicolai Heidlas, Royalty free music from HookSounds.\n\nSFX:\nSounds by Frank Serafine, SFX Bible, Airborne Sound and Blastwave FX from Soundsnap. Other sounds from the UI SFX collection by Stuart Duffield (available on Corona Marketplace).'
local frenchCredits = 'Snack Lab\n(c)2017 Greg McDonald\n\nConcept: Thomas and Greg McDonald\n\nProgrammation: Greg McDonald\n\nRédaction: Thomas et Greg McDonald\n\nGraphism:\nIcônes créées par Madebyoliver, Freepix et Puppets de Flaticon. Autres images par Greg et Thomas McDonald\n\nMusique:\n“Curious” par Nicolai Heidlas: musique libre de droits disponible sur HookSounds (Attribution Creative Commons 4.0).\n\nEffets sonores:\nEnregistrements de Frank Serafine, SFX Bible, Airborne Sound et Blastwave FX disponibles sur Soundsnap. D\'autres enregistrements ont été tirés de la collection UI SFX de Stuart Duffield (disponible au Corona Marketplace).'


local parentsGuide_en = '“Dad, make your next game one that doesn’t have any learning... and where you can do cooking and science.”'
local parentsGuide_fr = '«Papa, j’aimerais que ton prochain jeu ne soit pas pour apprendre des affaires. Et on peut cuisiner et faire de la science dedans.»'

local strings = {}

strings[ 'lang_en' ] =
{
	parents = 'Grownups!',
	parentsGuide = parentsGuide_en,
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
	parents = 'Allô l\'Adulte!',
	parentsGuide = parentsGuide_fr,
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

strings[ 'lang_jp' ] =
{
	parents = '大人',
	parentsGuide = parentsGuide_en,
	bestScore = 'ベストレーティング',
	patience = 'ちんちゃく',
	blenderActionPresent = 'ブレンド',
	blenderActionPast = 'ブレンド',
	dummyActionPresent = 'ダミー',
	dummyActionPast = 'ダミー',
	grinderActionPresent = 'グラインド',
	grinderActionPast = '地面',
	pressActionPresent = '押す',
	pressActionPast = '押された',
	credits = englishCredits,
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
