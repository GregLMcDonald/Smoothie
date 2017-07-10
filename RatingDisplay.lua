local RatingDisplay = {}

local Rating = require 'Rating'

function RatingDisplay.new()


	local result = display.newGroup()

	local ratingOutline = display.newImage( 'image/ui/starsOutline.png' )
	ratingOutline.alpha = 0.3
	ratingOutline.anchorX = 0

	result.width = ratingOutline.width
	result.height = ratingOutline.height
	result.rating = 10

	result.halfStars = {}

	for i=1,10 do
		local obj = display.newImage( 'image/ui/starsFill-'..tostring(i)..'.png')
		obj:setFillColor( 1,1,0 )
		--[[
		if i <= 2 then
			obj:setFillColor( 1,0,0 )
		elseif i <= 6 then
			obj:setFillColor( 1,1,0 )
		else
			obj:setFillColor( 0,1,0 )
		end
		]]
		obj.anchorX = 0
		result:insert( obj )
		table.insert( result.halfStars, obj )
		
	end
	
	result:insert( ratingOutline )
	--ratingOutline:removeSelf( )

	function result:setRating( value )



		if value > Rating.maxValue then value = Rating.maxValue end
		if value < Rating.minValue then value = Rating.minValue end


		local fractionOfMaximumRating = value / Rating.maxValue
		local numberOfHalfStars = math.ceil( fractionOfMaximumRating * 10 )
		
		for i = 1, 10 do
			local obj = self.halfStars[i]
			transition.cancel( obj )

			local transitionTime = 150 + (10 - i) * 45
			
			if i > numberOfHalfStars then
				transition.fadeOut( obj, { time = transitionTime } )
			else 
				transition.fadeIn( obj, { time = transitionTime } ) 
			end
		end

	end

	function result:removeRatingDisplay()
		for i=10,1,-1 do
			self.halfStars[i]:removeSelf( )
			self.halfStars[i] = nil
		end

	end

	return result
end

return RatingDisplay