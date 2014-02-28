local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local sprite = require "sprite"

local image


function scene:createScene( event )
	local screenGroup = self.view
	
local options = 
{
	frames = {},
	sheetContentWidth = 1024,
	sheetContentHeight = 1024,
}

local frames = options.frames
for j=0,2 do
	for i=0,3 do

		local element = {
			x = i*256,
			y = j*256,
			width = 256,
			height = 256,
		}
		table.insert( frames, element )
	end
end

		local element = {
			x = 0,
			y = 3*256,
			width = 469,
			height = 256,
		}
		table.insert( frames, element )


	local sheet = graphics.newImageSheet( "mushroom_logo.png", options )		


	local mushroom = display.newSprite( sheet, { name="mushroom", start=1, count=12, time=900,loopCount=1} )

	mushroom.x = display.contentWidth/2
	mushroom.y = display.contentHeight/2 - mushroom.height/3
	mushroom:play()
	
	local logo = display.newSprite( sheet, { name="logo", start=13, count=1, time=0 } )
	logo.x = display.contentWidth/2
	logo.y = display.contentHeight/2 + logo.height - mushroom.height/2	logo:scale(0.6,0.6)
	

	screenGroup:insert(logo)	
	screenGroup:insert( mushroom )

end



function scene:enterScene( event )
	local function updateTime()
		 storyboard.gotoScene( "menu", "fade", 1000 )
	end	
	local clockTimer = timer.performWithDelay( 1000, updateTime, 1 )

end


function scene:exitScene( event )

end


function scene:destroyScene( event )
	

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene