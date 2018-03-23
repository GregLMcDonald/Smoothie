local DisplayTools = {}

function DisplayTools.surroundInColour( imageFilename, options )

	local group = display.newGroup( )

	local options = options or {}

	local frac = options.frac or 0.1
	local abs = options.abs
	local colour = options.colour or { 1,0,0 }

	local image = display.newImage( imageFilename )
	if image == nil then return nil end

	local outline = graphics.newOutline( 1, imageFilename )
	local poly = display.newPolygon( 0, 0, outline )
	poly:setFillColor( 1,1,1,0)
	poly:setStrokeColor( unpack( colour ) )
	local strokeWidth
	if abs then
		strokeWidth = abs
	else
		strokeWidth = frac * image.width
	end
	poly.strokeWidth = strokeWidth
	

	group:insert( poly )

	if image then
		group:insert( image )
	else
		print("where the image")
	end

	group.contentWidth = image.width + strokeWidth
	group.contentHeight = image.height + strokeWidth
	group.invariantWidth = group.contentWidth
	group.invariantHeight = group.contentHeight

	function group:setScale( scale )
		self.xScale = scale
		self.yScale = scale
		self.contentWidth = self.invariantWidth * scale
		self.contentHeight = self.invariantHeight * scale
	end

	
	return group

end

return DisplayTools