display.setStatusBar( display.HiddenStatusBar )
local screenW, screenH, halfW, halfH = display.contentWidth, display.contentHeight, display.contentWidth*0.5 , display.contentHeight*0.5 


display.setDefault( "background", 255, 255, 255 )

soundBackground = audio.loadStream("menu.mp3") 
soundSwup = audio.loadSound("swup.mp3")
soundDeth = audio.loadSound("die.mp3")
soundProcess = audio.loadSound("process.mp3")
soundGame = audio.loadStream("game.mp3") 
soundAir = audio.loadStream("air.mp3") 

require( "ice" )

local storyboard = require "storyboard"
storyboard.gotoScene( "loading", "fade", 500 )

