------------------------------------------------------------------------------
--
-- Title:  Ingredient.lua
-- Project: SnackLab
--
-- Author: Greg McDonald
---------------------------------------------------------------------------------

local Ingredient = {}

local Language = require( '_Assets.Language' )

function Ingredient.new()
	local result = {}

	function result:sampleLabel( returnDetails )

		local label = self.name or "LABEL"

		if true == returnDetails then
			label = {}
			label.text = self.name or 'LABEL'
		end


		local currentLanguage = Language.getCurrentLanguage()
		
		if self[ currentLanguage ] then
		
			if self[ currentLanguage ].sampleForm then

				if true == returnDetails then

					label.text = self[ currentLanguage ].sampleForm.text
					label.plural = self[ currentLanguage ].sampleForm.plural
					label.gender = self[ currentLanguage ].sampleForm.gender

				else

					label = self[ currentLanguage ].sampleForm.text

				end
				
			end

		end
		
		return label
	end

	function result:bulkLabel()
		local label = self.name or "LABEL"
		label = 'I like '..label
		return label
	end


	return result
end

return Ingredient