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

require "sprite"
local widget = require( "widget" )

local isPlay = false

local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5 , display.contentHeight*0.5 

local soundBackgroundChannel;

local part1,part2,sky1,sky2,logo

function scene:createScene( event )
	local screenGroup = self.view

    sky1 = display.newImage("sky_left.png")
    sky1:setReferencePoint(display.BottomLeftReferencePoint)
    sky1.x = 0-400
    sky1.y = 480
    sky1.speed = 1
    screenGroup:insert(sky1)

    sky2 = display.newImage("sky_right.png")
    sky2:setReferencePoint(display.BottomLeftReferencePoint)
    sky2.x = 800-400
    sky2.y = 480
    sky2.speed = 1
    screenGroup:insert(sky2)

    part1 = display.newImage("menu_back_left.png")
    part1:setReferencePoint(display.BottomLeftReferencePoint)
    part1.x = 0-406
    part1.y = 480
    part1.speed = 2
    screenGroup:insert(part1)

    part2 = display.newImage("menu_back_right.png")
    part2:setReferencePoint(display.BottomLeftReferencePoint)
    part2.x = 812-406
    part2.y = 480
    part2.speed = 2
    screenGroup:insert(part2)

    logo = display.newImage("logo.png")
    logo:setReferencePoint(display.BottomLeftReferencePoint)
    logo.x = 0
    logo.y = 180

    screenGroup:insert(logo)

    local heroSpriteSheet = sprite.newSpriteSheet("heroes.png", 85, 78)
    local heroSprites = sprite.newSpriteSet(heroSpriteSheet, 1, 8)
    sprite.add(heroSprites, "swap", 1, 8, 1000, 0)
    hero = sprite.newSprite(heroSprites)
    hero.x = halfW
    hero.y = halfH
    hero:prepare("swap")
    hero:play()
    screenGroup:insert(hero)

	local buttonStartPress = function( event )
		audio.stop()
		isPlay = false		--audio.fadeOut( { channel=0, time=400 } )
		storyboard.gotoScene( "game", "fade", 400 )
	end

	buttonStart = widget.newButton
	{
		defaultFile = "play0.png",
		overFile = "play1.png",

		emboss = true,
		onPress = buttonStartPress
	}	buttonStart.speed = 0.3	buttonStart.delta = 1
	buttonStart.x = display.contentCenterX + 80
	buttonStart.y = display.contentCenterY + 160
    screenGroup:insert(buttonStart)
	local buttonScorePress = function( event )
		storyboard.gotoScene( "score", "slideDown", 400 )
	end

	buttonScore = widget.newButton
	{
		defaultFile = "score0.png",
		overFile = "score1.png",
		emboss = true,
		onPress = buttonScorePress
	}	buttonScore.speed = 0.3	buttonScore.delta = -1	
	buttonScore.x = display.contentCenterX - 80
	buttonScore.y = display.contentCenterY + 160
    screenGroup:insert(buttonScore)
	
	if isPlay == false  then
	soundBackgroundChannel = audio.play(soundBackground, {loops = -1})
	isPlay = true
	end

end
function scrollButton(self,event)	self.y = self.y + self.speed * self.delta
	if self.y < display.contentCenterY + 160 -8 or self.y > display.contentCenterY + 160 +8 then		self .delta = -self .delta
	end
end
 function scrollSky()
	sky1.x = sky1.x - sky1.speed
	sky2.x = sky2.x - sky2.speed
	
	if sky1.x <= -800-128 then
		sky1.x = 800-128
	end
	if sky2.x <= -800-128 then
		sky2.x = 800-128
	end		
end

 function scrollBackground()
	part1.x = part1.x - part1.speed
	part2.x = part2.x - part2.speed
	
	if part1.x <= -812-128 then
		part1.x = 812-128
	end
	if part2.x <= -812-128 then
		part2.x = 812-128
	end		
end

function scene:enterScene(event)
	storyboard.purgeScene( "score" )
	storyboard.purgeScene( "game" )	
	buttonStart.enterFrame = scrollButton
	Runtime:addEventListener("enterFrame", buttonStart)		buttonScore.enterFrame = scrollButton
	Runtime:addEventListener("enterFrame", buttonScore)		
	part1.enterFrame = scrollBackground
	Runtime:addEventListener("enterFrame", part1)
	
	sky1.enterFrame = scrollSky
	Runtime:addEventListener("enterFrame", sky1)		
end

function scene:exitScene(event)
	Runtime:removeEventListener("enterFrame", part1)
	Runtime:removeEventListener("enterFrame", sky1)	Runtime:removeEventListener("enterFrame", buttonStart)	Runtime:removeEventListener("enterFrame", buttonScore)	
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

