local GraphicComment = {}

local Ingredients = require '_Culinary.Ingredients'
local ingredientList
local ingredientListKeys
ingredientList, ingredientListKeys = Ingredients.getList()


--[[

In directory with image files:

	ls -1 >> temp
	cat temp | sed /\.png/s/// >> temp2
	cat temp2 | sed /.*/s//\"\&\",/

and copy&paste list from stdout. 
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
"temp",
"therefore",
"times",
}
local mathList = {}
for i=1,#mathNames do
	local name = mathNames[ i ]
	mathList[ name ] = true
end

local emoticonList = {}
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
	"temp",
	"thinking",
	"tired",
	"unamused",
	"vomiting",
	"weeping",
	"wink",
	"winkingTongue",
	"zombie",
}
for i=1,#emoticonNames do
	local name = emoticonNames[ i ]
	emoticonList[ name ] = true
end






function GraphicComment.new( commentString, options )
	
	--local result = display.newGroup()

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
					imageFilename = '__image/emoticons/'..name..'.png'
				end

			elseif class == 'math' then

				if mathList[ name ] then
					imageFilename = '__image/math/'..name..'.png'
				end

			end




		else

			if token == 'me' then
				if customer then
					imageFilename = customer.avatarImageFilename
				end
			end


		end

		print(token,imageFilename)

	end


	-- instantiate DisplayObjects and add to group in correct position





	--return result

end

--[[

angel.png
angry.png
cool.png
devil.png
dizzy.png
expressionless.png
eyesClosedBigGrinHappy.png
eyesClosedBigSmile.png
eyesClosedHappy.png
eyesOpenTongue.png
happy.png
happySweating.png
inLove.png
injured.png
kiss.png
kissHeart.png
kissWink.png
masked.png
momentOfSilence.png
mute.png
neutral.png
openMouthCool.png
passedOutGreen.png
passedOutTongueOut.png
rainbowVomiting.png
sad.png
scared.png
scaredBlue.png
secret.png
shocked.png
shutOutTheWorld.png
sick.png
singleTear.png
sleeping.png
smile.png
smirking.png
squintingTongue.png
starrySmiling.png
stunnedSurprise.png
sweat.png
tearsOfJoy.png
teethRattling.png
temp
thinking.png
tired.png
unamused.png
vomiting.png
weeping.png
wink.png
winkingTongue.png
zombie.png

]]

return GraphicComment