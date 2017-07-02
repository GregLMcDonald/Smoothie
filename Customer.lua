local Customer = {}

function Customer.new( options )
	
	local options = options or {}

	local _customer


	function _customer:rateRecipe( recipe )
		local rating = 0
		return rating
	end


	function _customer:respondToRecipe( recipe )
		local response = ""

		return response
	end


	return _customer

end


return Customer