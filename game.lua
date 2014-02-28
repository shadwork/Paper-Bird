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

local scoresTable = ice:loadBox( "scores" )

local physics = require "physics"
physics.start()


-- The name of the ad provider.
local provider = "admob"

-- Your application ID
local appID = "a1530f2b3f698fa"

-- Load Corona 'ads' library
local ads = require "ads" 

local showAd

-- Set up ad listener.
local function adListener( event )

	local msg = event.response

	if event.isError then
		statusText:setTextColor( 255, 0, 0 )
		statusText.text = "Error Loading Ad"
		statusText.x = display.contentWidth * 0.5

		showAd( "banner" )
	else
		statusText:setTextColor( 0, 255, 0 )
		statusText.text = "Successfully Loaded Ad"
		statusText.x = display.contentWidth * 0.5
	end
end 

if appID then
	ads.init( provider, appID, adListener )
end 

-- Shows a specific type of ad
showAd = function( adType )
	local adX, adY = display.screenOriginX, display.screenOriginY
	ads.show( adType, { x=adX, y=adY } )
end 


local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5 , display.contentHeight*0.5 


local soundGameChanne;


local soundAirChannel;

local holeShift =128
local hole =104

local score = 0
local scoreMeter

local part1,part2,sky1,sky2,logo,theFloor,theTop,result1,result2,result3,finger

local pause = true;
local speedVector = -1

local blocks= {} 

function scene:createScene( event )
	local screenGroup = self.view


    theFloor = display.newImage("floor.png")
    theFloor:setReferencePoint(display.BottomLeftReferencePoint)
    theFloor.x = -128
    theFloor.y = 480
    physics.addBody(theFloor, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(theFloor)

    theTop = display.newImage("floor.png")
    theTop:setReferencePoint(display.BottomLeftReferencePoint)
    theTop.x = -128
    theTop.y = -16
    physics.addBody(theTop, "static", {density=.1, bounce=0.1, friction=.2})
    screenGroup:insert(theTop)


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


	for i = 1, 8, 1 do
		local line = display.newImage("contur.png")
	    line:setReferencePoint(display.TopLeftReferencePoint)
		line.speed = 4 
	    line.x = halfW + 54*4 * i
	    line.y = math.random(holeShift,screenH-holeShift)
	    line.cross = false
	    if i==1 then
		    line.y = math.random(holeShift +hole,screenH-(holeShift-hole))
	    end
	    physics.addBody(line, "static", {density=.1, bounce=0.1, friction=.2})
	    screenGroup:insert(line)		
		blocks[i*2] = line
		local lineTop = display.newImage("line.png")
	    lineTop:setReferencePoint(display.BottomLeftReferencePoint)
	    lineTop.x = line.x
	    lineTop.y = line.y - hole
	    physics.addBody(lineTop, "static", {density=.1, bounce=0.1, friction=.2})
	    screenGroup:insert(lineTop)		
		blocks[1 + i*2] = lineTop		
	end	
	
    local heroSpriteSheet = sprite.newSpriteSheet("heroes.png", 85, 78)
    local heroSprites = sprite.newSpriteSet(heroSpriteSheet, 1, 8)
    sprite.add(heroSprites, "swap", 1, 7, 500, 1)
    sprite.add(heroSprites, "stay", 6, 1, 1000, 0)    
    hero = sprite.newSprite(heroSprites)
    hero.x = halfW
    hero.y = halfH
    hero:prepare("stay");
    hero:play("stay")
    physics.addBody(hero, "static", {density=.1, bounce=0.1, friction=.2, radius=2.1})
    screenGroup:insert(hero)


    local fingerSpriteSheet = sprite.newSpriteSheet("finger.png", 128, 110)
    local fingerSprites = sprite.newSpriteSet(fingerSpriteSheet, 1, 7)
    sprite.add(fingerSprites, "push", 1, 6, 500, 0)
    sprite.add(fingerSprites, "stop", 1, 1, 500, 0)    
    finger = sprite.newSprite(fingerSprites)
    finger.x = halfW
    finger.y = screenH-8
    finger:setReferencePoint(display.BottomLeftReferencePoint)
    finger:prepare("push");
    finger:play("push")
    screenGroup:insert(finger)

	local options = 
	{
	    text = "0",     
	    x = halfW,
	    y = 48,
	    font = "Trubble",   
	    fontSize = 64,
	    align = "center"
	}

	scoreMeter = display.newText(options)
	scoreMeter:setTextColor( 11, 11, 11, 255 )	
	scoreMeter.isVisible = false
    screenGroup:insert(scoreMeter)

	result1 = display.newImage("level1.png")

    result1.x = halfW
    result1.y = halfH
    result1:scale( 0.1, 0.1 )
    result1.isVisible = false
    screenGroup:insert(result1)

	result2 = display.newImage("level2.png")    
    result2.x = halfW
    result2.y = halfH
    result2:scale( 0.1, 0.1 )    
    result2.isVisible = false    
    screenGroup:insert(result2)

	result3 = display.newImage("level3.png")    
    result3.x = halfW
    result3.y = halfH
    result3:scale( 0.1, 0.1 )    
    result3.isVisible = false
    screenGroup:insert(result3)

end

function rotateBird(self ,event)
	if speedVector==-1 then
		speedVector = self.y
	else	
		local deltaSpeed = speedVector-self.y;
		speedVector = self.y		
		self.rotation = - deltaSpeed*5
		if self.rotation>90 then 
			self.rotation = 90
		end
		if self.rotation<-45 then 
			self.rotation = -45
		end		
		
	end
	
end

local function onCollision(event)
	if event.phase == "began" then
	    hero.bodyType = "static"	    
   	    audio.play(soundDeth) 
	Runtime:removeEventListener("enterFrame", scrollBlock)	   	    
	Runtime:removeEventListener("enterFrame", sky1)	
	Runtime:removeEventListener("enterFrame", part1)	
	Runtime:removeEventListener("enterFrame", hero)	
	Runtime:removeEventListener("touch", touchScreen)	
	Runtime:removeEventListener("collision", onCollision)	
	
	local sc1 =  scoresTable:retrieve( "score1" ) or 0 
	local sc2 =  scoresTable:retrieve( "score2" ) or 0 
	local sc3 =  scoresTable:retrieve( "score3" ) or 0 		
	
	local scfactor = 0.75
	
	if score >sc1 then		
		    result1.isVisible = true		    		    
	    	scoresTable:store( "score3", sc2 )
	    	scoresTable:store( "score2", sc1 )
	    	scoresTable:store( "score1", score )	    	
			transition.to( result1, { time=1000, yScale=scfactor,xScale=scfactor} ) 
			scoresTable:save()
	elseif  score >sc2 then			
		    result2.isVisible = true		    		    
	    	scoresTable:store( "score3", sc2 )
	    	scoresTable:store( "score2", score )
			transition.to( result2, { time=1000, yScale=scfactor,xScale=scfactor} ) 	    	
			scoresTable:save()			
	elseif  score >sc3 then			
		    result3.isVisible = true		    		    
	    	scoresTable:store( "score3", score )
			transition.to( result3, { time=1000, yScale=scfactor,xScale=scfactor} ) 
			scoresTable:save()		
	end		

   	    timer.performWithDelay(1000, gameOver, 1)  	 	
	end
end

function gameOver()
	storyboard.gotoScene("menu", "fade", 400)
end

function scrollBlock(self ,event)
	for i = 1, 8, 1 do
		if blocks[i*2].cross == false then
			if blocks[i*2].x < hero.x and blocks[i*2].x + 54 >hero.x then
				blocks[i*2].cross=true
				audio.play(soundProcess) 
				score = score +1
				scoreMeter.text = score
			end
		end
		
		blocks[i*2].x = blocks[i*2].x - blocks[i*2].speed
		blocks[1+i*2].x = blocks[i*2].x
		if blocks[i*2].x <= -54*4*3 then
			blocks[i*2].cross=false
		    blocks[i*2].x = halfW + 54 + 54 * 4 * 4
		    blocks[i*2].y = math.random(holeShift,screenH-holeShift)
		    blocks[1+i*2].x =  blocks[i*2].x
		    blocks[1+i*2].y = blocks[i*2].y - hole
		end	
	end		
	
end

function touchScreen(event)
   if event.phase == "began" then
   	if pause then
   		pause = false
   		audio.stop()   		
   		soundBackgroundChannel = audio.play(soundGame, {loops = -1})
   		
   		ads.hide()
   		
   		finger.isVisible = false 
		    finger:prepare("stop");
		    finger:play("stop")
   		scoreMeter.isVisible = true

	   	transition.to( hero, { time=2500, x= hero.x - halfW/2} )
   		
			local function scrollSky(self ,event)
				sky1.x = sky1.x - sky1.speed
				sky2.x = sky2.x - sky2.speed
				
				if sky1.x <= -800-128 then
					sky1.x = 800-128
				end
				if sky2.x <= -800-128 then
					sky2.x = 800-128
				end		
			end
			
			local function scrollBackground(self ,event)
				part1.x = part1.x - part1.speed
				part2.x = part2.x - part2.speed
				
				if part1.x <= -812-128 then
					part1.x = 812-128
				end
				if part2.x <= -812-128 then
				part2.x = 812-128
				end		
			end   		
   		
   		 part1.enterFrame = scrollBackground
			Runtime:addEventListener("enterFrame", part1)
	
			sky1.enterFrame = scrollSky
			Runtime:addEventListener("enterFrame", sky1)
			
			Runtime:addEventListener("enterFrame", scrollBlock)			
			
			hero.bodyType = "dynamic" 		   	
   	else
	   	hero:applyForce(0, -0.3, hero.x, hero.y) 
   		hero:prepare("swap")
   	    hero:play()	
   	    audio.play(soundSwup) 
   	end	
   	
   end
   
   if event.phase == "ended" then
   	
   end

end


function scene:enterScene(event)
	pause = true;
	speedVector = -1
	score = 0

	
	storyboard.purgeScene( "menu" )
	Runtime:addEventListener("touch", touchScreen) 
	hero.enterFrame = rotateBird
	Runtime:addEventListener("enterFrame", hero)
	Runtime:addEventListener("collision", onCollision) 	
		--showAd( "banner" ) 	
	soundAirChannel = audio.play(soundAir, {loops = -1})
end

function scene:exitScene(event)
	Runtime:removeEventListener("enterFrame", scrollBlock)		
	Runtime:removeEventListener("enterFrame", sky1)	
	Runtime:removeEventListener("enterFrame", part1)	
	Runtime:removeEventListener("enterFrame", hero)	
	Runtime:removeEventListener("touch", touchScreen)	
	Runtime:removeEventListener("collision", onCollision)	
	audio.stop()
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

