---------------------------------------------------------------------------------
--
-- scene1.lua
--
---------------------------------------------------------------------------------


local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------


-- Touch event listener for background image
local function onSceneTouch( self, event )
	print("Enter TOUCH")
	if event.phase == "began" then
		
		
		return true
	end
end

local gameNetwork = require( "gameNetwork" )
local playerName

local function loadLocalPlayerCallback( event )
   playerName = event.data.alias
   saveSettings()  --save player data locally using your own "saveSettings()" function
end

local function gameNetworkLoginCallback( event )
   gameNetwork.request( "loadLocalPlayer", { listener=loadLocalPlayerCallback } )
   return true
end

local function gpgsInitCallback( event )
   gameNetwork.request( "login", { userInitiated=true, listener=gameNetworkLoginCallback } )
end

local function gameNetworkSetup()
   if ( system.getInfo("platformName") == "Android" ) then
      gameNetwork.init( "google", gpgsInitCallback )
   else
      gameNetwork.init( "gamecenter", gameNetworkLoginCallback )
   end
end

local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      gameNetworkSetup()  --login to the network here
   end
   return true
end


-- Called when the scene's view does not exist:
function scene:create( event)
	
	--[[
	parameters = event.params
	
	gameNetwork = parameters.gameNetwork
	thing  = parameters.thing
	--]]
	local sceneGroup = self.view
	
	gameNetworkSetup()
	
	local bg = display.newImageRect( "bg.jpg", display.contentWidth, display.contentHeight)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY
	sceneGroup:insert(bg)

	
	ttls = display.newText("A N G R Y", display.contentCenterX+3, 27, "Feast of Flesh BB", 67)
	ttls:setFillColor(0,0,0)
	sceneGroup:insert(ttls)
	ttls2 = display.newText("FLAPPY BIRD", display.contentCenterX+3, 80, "Feast of Flesh BB", 67)
	ttls2:setFillColor(0,0,0)
	sceneGroup:insert(ttls2)

	ttl = display.newText("A N G R Y", display.contentCenterX, 30, "Feast of Flesh BB", 67)
	sceneGroup:insert(ttl)
	ttl2 = display.newText("FLAPPY BIRD", display.contentCenterX, 83, "Feast of Flesh BB", 67)
	sceneGroup:insert(ttl2)

	ab = display.newImage('angrybird.png')
	ab:translate(display.contentCenterX,170)
	ab:scale(1.5,1.5)
	sceneGroup:insert(ab)

	rtb = display.newImage('button.png')
	rtb:translate(display.contentCenterX, 255)
	rtb:scale(0.15,0.15)
	sceneGroup:insert(rtb)

	rkb = display.newImage('button.png')
	rkb:translate(display.contentCenterX+100, 355)
	rkb:scale(0.15,0.15)
	sceneGroup:insert(rkb)	
	rkb:addEventListener('touch',rkb)


	--ttl:translate(display.contentCenterX, 60)
	--sceneGroup:insert( ttl2 )
	--ttl2 = display.newImage('title2.png')
	--ttl2:translate(display.contentCenterX+2,56)


--[[function rt:touch( event )
    if event.phase == "began" then
    	composer.gotoScene( "game", "slideLeft", 800  )
	
        return true
    end
end]]

	
	plb = display.newImage('button.png')
	plb:translate(display.contentCenterX-100, 355)
	plb:scale(0.15,0.15)

		
function plb:touch( event )
    if event.phase == "began" then
	--print ('gameNetwork ' .. gameNetwork)
		options = {
			effect = "slideLeft",
			time = 800,
			params = {
				--gameNetwork = gameNetwork
			}
		}
    	composer.gotoScene( "game", options )
	
        return true
    end
end
function rkb:touch (event)
	if ( system.getInfo("platformName") == "Android" ) then
		gameNetwork.show( "leaderboards" )
	else
		gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
	end
	return true
end
	plb:addEventListener( "touch", plb )




--rt.touch=onSceneTouch
--rt.clic=onSceneTouch
	
	sceneGroup:insert( plb )

	local font = native.newFont("Gargle Cd Rg", 16)
	--rt = display.newText("RATE", display.contentCenterX, 250, "Gargle Cd Rg", 40)
	rt = display.newText("RATE", display.contentCenterX, 250)
	rt.font = font
	rt.size = 36
	
	sceneGroup:insert(rt)

	pl = display.newText("PLAY", display.contentCenterX-100, 350, "Gargle Cd Rg", 40)
	sceneGroup:insert(pl)

	rk = display.newText("LEADERBOARD", display.contentCenterX+100, 353, "Gargle Cd Rg", 19)
	sceneGroup:insert(rk)
	
	crd = display.newText("Delta Team // Dev.f // 2015", display.contentCenterX+2, 442, "Gargle Cd Rg", 22)
	sceneGroup:insert(crd)
	crd2 = display.newText("Delta Team // Dev.f // 2015", display.contentCenterX, 440, "Gargle Cd Rg", 22)
	sceneGroup:insert(crd)
	crd:setFillColor(0,0,0)
	print( "\n1: create event")
end



function scene:show( event )




	local phase = event.phase
	
	if "did" == phase then
	
		print( "1: show event, phase did" )
	
	end
	
end

function scene:hide( event )
	
	local phase = event.phase
	
	if "will" == phase then
	
	
	end
	
end

function scene:destroy( event )
	print( "((destroying scene 1's view))" )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene