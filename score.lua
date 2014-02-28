-- Project: PaperBird
-- Description:
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2014 . All Rights Reserved.
---- cpmgen main.lua

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local scoresTable = ice:loadBox( "scores" )

require "sprite"
local widget = require( "widget" )

local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5 , display.contentHeight*0.5 

local score = 0

local score1 = 0
local score2 = 0
local score3 = 0

local part1,sky1,sky2

function scene:createScene( event )
	local screenGroup = self.view

    sky1 = display.newImage("sky_left.png")
    sky1:setReferencePoint(display.BottomLeftReferencePoint)
    sky1.x = 0-400
    sky1.y = 480+128
    sky1.speed = 1
    screenGroup:insert(sky1)

    sky2 = display.newImage("sky_right.png")
    sky2:setReferencePoint(display.BottomLeftReferencePoint)
    sky2.x = 800-400
    sky2.y = 480+128
    sky2.speed = 1
    screenGroup:insert(sky2)

	local buttonBackPress = function( event )
		storyboard.gotoScene( "menu", "slideUp", 400 )
	end

	buttonBack = widget.newButton
	{
		defaultFile = "back0.png",
		overFile = "back1.png",

		emboss = true,
		onPress = buttonBackPress
	}
	
	buttonBack.speed = 0.3
	buttonBack.delta = -1		
	buttonBack.x = display.contentCenterX - 0
	buttonBack.y = display.contentCenterY + 160

    local tourn = display.newImage("scores.png")
    tourn:setReferencePoint(display.TopLeftReferencePoint)
    tourn.x = 0
    tourn.y = 0+16
    screenGroup:insert(tourn)	

	local options = 
	{
	    text = "0",     
	    x = halfW,
	    y = 200,

	    font = "Trubble",   
	    fontSize = 52,
	    align = "center"
	}

	local sco0 = display.newText(options)
	sco0:setTextColor( 0, 0, 0, 255 )	
	sco0.y = 290+16	
    screenGroup:insert(sco0)
    sco0.text =  scoresTable:retrieve( "score3" ) or 0 

	local sco1 = display.newText(options)
	sco1:setTextColor( 0, 0, 0, 255 )	
	sco1.y = 80+16
    screenGroup:insert(sco1)
    sco1.text = scoresTable:retrieve( "score1" ) or 0 

	local sco2 = display.newText(options)
	sco2.y = 184+16
	sco2:setTextColor( 0, 0, 0, 255 )	
    screenGroup:insert(sco2)
    sco2.text = scoresTable:retrieve( "score2" ) or 0 


    screenGroup:insert(buttonBack)

end

 function scrollSkyScore()
	sky1.x = sky1.x - sky1.speed
	sky2.x = sky2.x - sky2.speed
	
	sky1.y = (480+128) + 16 * math.sin(sky1.x/64)
	sky2.y = (480+128) + 8 * math.cos(sky1.x/64)	
	
	if sky1.x <= -800-128 then
		sky1.x = 800-128
	end
	if sky2.x <= -800-128 then
		sky2.x = 800-128
	end		
end


function scene:enterScene(event)
	storyboard.purgeScene( "menu" )
	
	sky1.enterFrame = scrollSkyScore
	Runtime:addEventListener("enterFrame", sky1)

	buttonBack.enterFrame = scrollButton
	Runtime:addEventListener("enterFrame", buttonBack)	

end

function scene:exitScene(event)
	Runtime:removeEventListener("enterFrame", sky1)
	Runtime:removeEventListener("enterFrame", buttonBack)
end

function scene:destroyScene(event)

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

scene:addEventListener( "createScene", scene )

scene:addEventListener( "enterScene", scene )

scene:addEventListener( "exitScene", scene )

scene:addEventListener( "destroyScene", scene )

return scene

