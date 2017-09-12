local GraphicComment = {}

--==========================================
--   CONSTANTS

local scale = 40 / 512
local interlineSpacing = 50



local Ingredients = require '_Culinary.Ingredients'
local ingredientList
local ingredientListKeys
ingredientList, ingredientListKeys = Ingredients.getList()




--[[

In directory with image files:

	ls -1 >> temp
	cat temp | sed /\.png/s/// >> temp2
	cat temp2 | sed /.*/s//\"\&\",/

and copy&paste list from stdout. Remove "temp", "temp2", etc. from list
]]

local mathNames = {
	"because",
	"divide",
	"emptySet",
	"equals",
	"forAll",
	"identicalTo",
	"implies",
	"infinity",
	"isGreaterThan",
	"isLessThan",
	"minus",
	"pencilAndRuler",
	"percent",
	"pi",
	"pieGraph",
	"plus",
	"plusOrMinus",
	"therefore",
	"times",
	"doesNotEqual",
}
local mathList = {}
for i=1,#mathNames do
	local name = mathNames[ i ]
	mathList[ name ] = true
end
mathNames = nil
local function getMathImageFilename( base )
	return '__image/math/'..base..'.png'
end


local emoticonNames = {
	"angel",
	"angry",
	"cool",
	"devil",
	"dizzy",
	"expressionless",
	"eyesClosedBigGrinHappy",
	"eyesClosedBigSmile",
	"eyesClosedHappy",
	"eyesOpenTongue",
	"happy",
	"happySweating",
	"inLove",
	"injured",
	"kiss",
	"kissHeart",
	"kissWink",
	"masked",
	"momentOfSilence",
	"mute",
	"neutral",
	"openMouthCool",
	"passedOutGreen",
	"passedOutTongueOut",
	"rainbowVomiting",
	"sad",
	"scared",
	"scaredBlue",
	"secret",
	"shocked",
	"shutOutTheWorld",
	"sick",
	"singleTear",
	"sleeping",
	"smile",
	"smirking",
	"squintingTongue",
	"starrySmiling",
	"stunnedSurprise",
	"sweat",
	"tearsOfJoy",
	"teethRattling",
	"thinking",
	"tired",
	"unamused",
	"vomiting",
	"weeping",
	"wink",
	"winkingTongue",
	"zombie",
}

local emoticonList = {}
for i=1,#emoticonNames do
	local name = emoticonNames[ i ]
	emoticonList[ name ] = true
end
emoticonNames = nil
local function getEmoticonImageFilename( base )
	return '__image/emoticons/'..base..'.png'
end


local punctuationNames = {
	"comma",
	"ellipsis",
	"emDash",
	"exclamation",
	"period",
	"question",
	"tripleExclamation",
	"colon",
}

local punctuationList = {}
for i=1,#punctuationNames do
	local name = punctuationNames[ i ]
	punctuationList[ name ] = true
end
punctuationNames = nil
local function getPunctuationImageFilename( base )
	return '__image/punctuation/'..base..'.png'
end


local animalNames = {
	"bear",
	"cat",
	"chicken",
	"cow",
	"dog",
	"frog",
	"gorilla",
	"monkey",
	"pig",
	"tiger",
}
local animalList = {}
for i=1,#animalNames do
	local name = animalNames[ i ]
	animalList[ name ] = true
end
animalNames = nil
local function getAnimalImageFilename( base )
	return '__image/animals/'..base..'.png'
end





function GraphicComment.new( commentString, options )
	
	local result = display.newGroup()

	local options = options or {}
	local customer = options.customer
	local maxWidth = options.maxWidth or 0.8 * display.contentWidth


	-- split comment into tokens
	local tokens = {}

	-- '(\{[%a\:]+\})'
	for v in string.gmatch( commentString, '\{([%a\:]+)\}' ) do
		table.insert( tokens, v )
	end


	-- lookup image file for each token

	local imageFilenames = {}

	for i=1,#tokens do

		local token = tokens[ i ]

		local imageFilename = nil
		
		if string.find( token, '\:' ) then

			local class
			local name
			class,name = string.match(token, '(%a+)\:(%a+)')
			
			if class == 'ingredient' then

				if ingredientList[ name ] then 
					imageFilename = ingredientList[ name ].imageFilename
				end

			elseif class == 'emoticon' then

				if emoticonList[ name ] then
					imageFilename = getEmoticonImageFilename( name )
				end

			elseif class == 'math' then

				if mathList[ name ] then
					imageFilename = getMathImageFilename( name )
				end

			elseif class == 'punctuation' then

				if punctuationList[ name ] then
					imageFilename = getPunctuationImageFilename( name )
				end

			elseif class == 'animal' then

				if animalList[ name ] then
					imageFilename = getAnimalImageFilename( name )
				end

			end




		else

			if token == 'me' then
				if customer then
					imageFilename = customer.avatarImageFilename
				end
			
			elseif token == 'newline' then

				imageFilename = 'NEWLINE'

			end


		end

		if imageFilename == nil then
			print("WARNING unknown image for token",token)
			imageFilename = '__image/punctuation/unknownImage.png'
		end

		table.insert( imageFilenames, imageFilename )

	end


	-- instantiate DisplayObjects and add to group in correct position
	local x = 0
	local y = 0
	for i=1,#imageFilenames do
		local filename = imageFilenames[ i ]

		if filename == 'NEWLINE' then

			x = 0
			y = y + interlineSpacing

		else

			local image = display.newImage( filename )
			if image then

				image.xScale = scale
				image.yScale = scale

				image.x = x + 0.5 * image.contentWidth
				x = x + image.contentWidth

				image.y = y + 0.5 * image.contentHeight

				result:insert( image )

			end


		end

		
		
	end




	return result

end

function GraphicComment.testImageFilenames( verbose )

	for k,v in pairs( punctuationList ) do

		local name = getPunctuationImageFilename( k )
		local temp = display.newImage( name )
		if nil == temp then
			print("WARNING file not found",  name )
		else
			if true == verbose then
				print("OK", name)
			end
			temp:removeSelf( )
			temp = nil
		end
	end

	for k,v in pairs( mathList) do
		local name = getMathImageFilename( k )
		local temp = display.newImage( name )
		if nil == temp then
			print("WARNING file not found", name )
		else
			if true == verbose then
				print("OK",name)
			end
			temp:removeSelf( )
			temp = nil
		end
	end

	for k,v in pairs(emoticonList) do
		local name = getEmoticonImageFilename( k )
		local temp = display.newImage( name )
		if nil == temp then
			print("WARNING file not found", name )
		else
			if true == verbose then
				print("OK",name)
			end
			temp:removeSelf( )
			temp = nil
		end
	end

	for k,v in pairs(animalList) do
		local name = getAnimalImageFilename( k )
		local temp = display.newImage( name )
		if nil == temp then
			print("WARNING file not found", name )
		else
			if true == verbose then
				print("OK",name)
			end
			temp:removeSelf( )
			temp = nil
		end
	end

end

return GraphicComment