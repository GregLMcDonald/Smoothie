local ActionButtonWidget = {}

function ActionButtonWidget.new()

	local button = display.newGroup( )

    local buttonShape = display.newRoundedRect( 0, 0, 200, 40, 5)
    buttonShape:setFillColor( 37/255, 185/255, 154/255 ) -- as grey, this is 151/255 = 0.59215
    button.buttonShape = buttonShape
    button:insert( buttonShape )
    
    local function getButtonLabelObject( text )

        local buttonLabel = display.newText({
            text = string.upper( text ),
            fontSize = 30,
            font = 'HAMBH___.ttf',
            })
        buttonLabel:setFillColor( 1 )
        
        return buttonLabel
    end

    local labelText = 'process!'
    local buttonLabel = getButtonLabelObject( labelText )
    button.buttonLabel = buttonLabel
    button:insert( buttonLabel )

    button.isEnabled = false

    function button:setActionLabel( action )
        
        local newText = string.upper( action..'!')
        if newText ~= self.buttonLabel.text then

            local temp = getButtonLabelObject( self.buttonLabel.text )
            self:insert( temp )
            transition.to( temp, { alpha = 0, time = 100, onComplete = function() temp:removeSelf() end })

            transition.cancel( self )
            self.buttonLabel.alpha = 0
            self.buttonLabel.text = newText
            transition.to( self.buttonLabel, { alpha = 1, time = 100 })

        end
    end

    function button:setEnabled( state )
    	self.isEnabled = state
    	if true == state then
    		self.buttonShape:setFillColor( 37/255, 185/255, 154/255 )
    	else
    		self.buttonShape:setFillColor( 151/255 )
    	end
    end

    return button

end

return ActionButtonWidget