

local composer = require( "composer" )
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------
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

------HANDLE SYSTEM EVENTS------
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

function restart()
	--audio.rewind(bgmusicChannel)
	--audio.resume(bgmusicChannel)
	--media.playSound('music.mp3', true)
	vs = 0
	score = 0
	pipe1scoreAvailable = true
	pipe2scoreAvailable = true
	started = false
	lost = false
	--scoreTitle = display.newText("Score:", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
	--scoreTitle:setFillColor(0,0,0)
	scoreTitle.isVisible = true
	scoreTitle:toFront()
	--scorePoints = display.newText(score, display.contentCenterX, display.contentHeight/5, native.SystemFontBold, 20, 'left')
	--scorePoints:setFillColor(0,0,0)
	scorePoints.text = 0
	scorePoints.isVisible = true
	scorePoints:toFront()
	ab.x = display.contentWidth/4
	ab.y = 2*display.contentHeight/5
	ab.rotation = 0
	ab:toFront()
	--tapToStart = display.newText("Tap to start", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
	--tapToStart:setFillColor(0,0,0)
	tapToStart.isVisible = true
	tapToStart:toFront()
	
	pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 2 * display.contentHeight/10
	pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 5 * display.contentHeight/10
	
	pipe1upMid = pipe1rand - 2.5 / 10 * display.contentHeight
	pipe1downMid = (4.5 / 10 * display.contentHeight + pipe1rand) 
	pipe2upMid = pipe2rand - 2.5 / 10 * display.contentHeight
	pipe2downMid = (4.5 / 10 * display.contentHeight + pipe2rand)
	
	--pipe1Up = display.newRect(1.5*display.contentWidth, pipe1upMid, 2 * pipeWidth, pipe1rand)
	pipe1Up.x = 1.5 * display.contentWidth
	pipe1Up.y = pipe1upMid
	--pipe1Up.height = pipe1rand
	--pipe1Up:setFillColor(36/255,227/255,59/255)
	--pipe1Down = display.newRect(1.5*display.contentWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
	pipe1Down.x = 1.5*display.contentWidth
	pipe1Down.y = pipe1downMid
	--pipe1Down.height = 6 * display.contentHeight/10 - pipe1rand
	--pipe1Down:setFillColor(36/255,227/255,59/255)
	--pipe2Up = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2upMid, 2 * pipeWidth, pipe2rand)
	pipe2Up.x = 2 * display.contentWidth + pipeWidth
	pipe2Up.y = pipe2upMid
	--pipe2Up.height = pipe2rand
	--pipe2Up:setFillColor(36/255,227/255,59/255)
	--pipe2Down = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe2rand)
	pipe2Down.x = 2 * display.contentWidth + pipeWidth
	pipe2Down.y = pipe2downMid
	--pipe2Down.height = 6 * display.contentHeight/10 - pipe2rand
	--pipe2Down:setFillColor(36/255,227/255,59/255)
	gameOverText.isVisible = false
	newRecordText.isVisible = false
	recordText.isVisible = false
	scoreText.isVisible = false
	--floorBlock = display.newRect(display.contentCenterX, 9 * display.contentHeight/10, display.contentWidth, display.contentHeight/5)
	--floorBlock:setFillColor(163/255,152/255,100/255)
	--[[
	flapSound = audio.loadSound("flap.mp3")
	coinSound = audio.loadSound("coin_effect.mp3")
	yellSound = audio.loadSound("yell.mp3")
	--]]
	ab:toFront()
	scoreTitle:toFront()
	scorePoints:toFront()
end

	
function start()
	vs = 0
	floorlevel = 4 * display.contentHeight/5
	imageH = 50
	imageW = 50
	pipeWidth = display.contentWidth/12

	score = 0
	pipe1scoreAvailable = true
	pipe2scoreAvailable = true

	pipeMovement = display.contentWidth/70 -- 5
	fps = 30
	gvt = display.contentHeight/400 -- 2.4

	abH = display.contentHeight/40

	started = false
	lost = false
	
	--[[
	media.newEventSound("coin.mp3")
	media.newEventSound("yell.mp3")
	media.newEventSound("flap.mp3")
	]]
	
	--media.playSound("music.mp3", true)
	--bgmusic = audio.loadStream('music.mp3')
	--bgmusicChannel = audio.play(bgmusic, {loops = -1})
	--media.setSoundVolume(0.3)
	
	local gargle = native.newFont( "Gargle Cd Rg", 16 )
	local feast = native.newFont( "Feast of Flesh BB", 16)
	
	bg = display.newImageRect( "bg.jpg", display.contentWidth, display.contentHeight)
	--bg = display.newImageRect('maunaloa.jpg',display.contentWidth, display.contentHeight)
	bg.x = display.contentCenterX
	bg.y = display.contentCenterY

	--cuadrado = display.newRect(0,0, 50, 50)
	--cuadrado:setFillColor(1,1,1)
	
	scoreTitle = display.newText("Score:", display.contentCenterX, display.contentHeight/10, "Gargle Cd Rg", 20, 'left')
	scoreTitle:setFillColor(0,0,0)
	scoreTitle.font = gargle
	scoreTitle:toFront()

	scorePoints = display.newText(score, display.contentCenterX, display.contentHeight/5, "Gargle Cd Rg", 20, 'left')
	scorePoints:setFillColor(0,0,0)
	scorePoints.font = gargle
	scorePoints:toFront()

	ab = display.newImage('angrybird.png')
	ab:translate(display.contentWidth/4, 2*display.contentHeight/5)
	ab:scale((display.contentHeight/20)/imageH,((display.contentHeight/20)/imageH))
	ab:toFront()

	tapToStart = display.newText("Tap to start", display.contentCenterX, display.contentCenterY, "Gargle Cd Rg", 20, 'left')
	tapToStart:setFillColor(0,0,0)
	tapToStart:toFront()
	tapToStart.font = gargle

	pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 2 * display.contentHeight/10
	pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 5 * display.contentHeight/10 

	pipe1upMid = pipe1rand - 2.5 / 10 * display.contentHeight
	pipe1downMid = (4.5 / 10 * display.contentHeight + pipe1rand) 
	pipe2upMid = pipe2rand - 2.5 / 10 * display.contentHeight
	pipe2downMid = (4.5 / 10 * display.contentHeight + pipe2rand)

	--pipe1Up = display.newImageRect('pipe2.png', 2 * pipeWidth, pipe1rand)
	pipe1Up = display.newImageRect('pipe2.png', 2* pipeWidth, 1/2 * display.contentHeight)
	pipe1Up.x = 1.5*display.contentWidth
	pipe1Up.y = pipe1upMid

	--pipe1Down = display.newImageRect('pipe.png', 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
	pipe1Down = display.newImageRect('pipe.png', pipeWidth * 2, 1 / 2 * display.contentHeight)
	pipe1Down.x = 1.5*display.contentWidth
	pipe1Down.y = pipe1downMid

	--pipe2Up = display.newImageRect('pipe2.png', 2 * pipeWidth, pipe2rand)
	pipe2Up = display.newImageRect('pipe2.png', 2* pipeWidth, 1/2 * display.contentHeight)
	pipe2Up.x = display.contentWidth * 2 + pipeWidth
	pipe2Up.y = pipe2upMid

	--pipe2Down = display.newImageRect('pipe.png', 2 * pipeWidth, 6 * display.contentHeight/10 - pipe2rand)
	pipe2Down = display.newImageRect('pipe.png', 2 * pipeWidth, 1/2 * display.contentHeight)
	pipe2Down.x = display.contentWidth * 2 + pipeWidth
	pipe2Down.y = pipe2downMid


	--floorBlock = display.newImageRect('floor.png', display.contentWidth, display.contentHeight/5)
	floorBlock = display.newImageRect('lava.png', display.contentWidth, 7 * display.contentHeight/20)
	floorBlock.width = 14/12 * display.contentWidth
	floorBlock.x = display.contentCenterX
	floorBlock.y = 9 * display.contentHeight/10
	
	tryAgainButton = display.newImage('button.png')
	tryAgainButton:translate(display.contentWidth/4, 13 * display.contentHeight/20)
	tryAgainButton:scale(0.15,0.15)
	tryAgainText = display.newText("TRY AGAIN", display.contentWidth/4, (13 * display.contentHeight/20)-5, "Gargle Cd Rg", 27)
	tryAgainButton.isVisible = false
	tryAgainText.font = gargle
	tryAgainText.isVisible = false

	leaderboardButton = display.newImage('button.png')
	leaderboardButton:translate(3 * display.contentWidth/4, 13 * display.contentHeight/20)
	leaderboardButton:scale(0.15,0.15)
	leaderboardText = display.newText("LEADERBOARD", 3 * display.contentWidth/4, (13 * display.contentHeight/20)-3, "Gargle Cd Rg", 19)
	leaderboardText.font = gargle
	leaderboardButton.isVisible = false
	leaderboardText.isVisible = false

	achievementButton = display.newImage('button.png') 
	achievementButton:translate(display.contentWidth/2, 16 * display.contentHeight/20)
	achievementButton:scale(0.15,0.15)
	achievementText = display.newText("ACHIEVEMENTS", display.contentWidth/2, (16 * display.contentHeight/20)-3, "Gargle Cd Rg", 18)
	achievementText.font = gargle
	achievementButton.isVisible = false
	achievementText.isVisible = false

	scoreText = display.newText('Score: ', display.contentCenterX, 4 * display.contentHeight/10, "Gargle Cd Rg", 20, 'left')
	scoreText:setFillColor(0,0,0)
	scoreText.font = gargle
	scoreText.isVisible = false

	recordText = display.newText('Record: ', display.contentCenterX, 5 * display.contentHeight/10, "Gargle Cd Rg", 20, 'left')
	recordText:setFillColor(0,0,0)
	recordText.font = gargle
	recordText.isVisible = false

	newRecordText = display.newText('NEW RECORD!' , display.contentCenterX, 3 * display.contentHeight/10, "Gargle Cd Rg", 20, 'left')
	newRecordText:setFillColor(1,140/255,0)
	newRecordText.font = gargle
	newRecordText.isVisible = false

	gameOverText = display.newText("GAME OVER", display.contentCenterX, display.contentHeight/10, "Gargle Cd Rg", 20, 'left')
	gameOverText:setFillColor(0,0,0)
	gameOverText.font = gargle
	gameOverText.isVisible = false

	ab:toFront()
	scoreTitle:toFront()
	scorePoints:toFront()
end


local function gravity (event)
	if vs < 0 then
		ab.rotation = 20
	else
		ab.rotation = -20
	end
	ab:translate(0,-vs)
	vs = vs - gvt
end

local function createNewPipe (pipeNumber)
	if pipeNumber == 1 then
		pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe1upMid = pipe1rand - 2.5 / 10 * display.contentHeight
		--pipe1downMid = (display.contentHeight + pipe1rand) / 2
		pipe1downMid = (4.5 / 10 * display.contentHeight + pipe1rand) 
		
		pipe1Up.x = display.contentWidth + pipeWidth
		pipe1Up.y = pipe1upMid
		--pipe1Up.height = pipe1rand

		pipe1Down.x = display.contentWidth + pipeWidth
		pipe1Down.y = pipe1downMid
		--pipe1Down.height = 6 * display.contentHeight/10 - pipe1rand
		
		ab:toFront()
		scoreTitle:toFront()
		scorePoints:toFront()
		
		pipe1scoreAvailable = true
	else
		pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe2upMid = pipe2rand - 2.5 / 10 * display.contentHeight
		--pipe2downMid = (display.contentHeight + pipe2rand) / 2
		pipe2downMid = (4.5 / 10 * display.contentHeight + pipe2rand)
		
		pipe2Up.x = display.contentWidth + pipeWidth
		pipe2Up.y = pipe2upMid
		--pipe2Up.height = pipe2rand

		pipe2Down.x = display.contentWidth + pipeWidth
		pipe2Down.y = pipe2downMid
		--pipe2Down.height = 6 * display.contentHeight/10 - pipe2rand
		
		ab:toFront()
		scoreTitle:toFront()
		scorePoints:toFront()
		
		pipe2scoreAvailable = true
	end
end

local function unlockAchievement (achievementID)
	gameNetwork.request( "unlockAchievement",
		{
			achievement =
			{
				identifier=achievementID, percentComplete=100, showsCompletionBanner=true
			},
			listener = achievementRequestCallback
		}
	)
end

local function movePipes (event)
	pipe1Up.x = pipe1Up.x - pipeMovement
	pipe1Down.x = pipe1Down.x - pipeMovement
	pipe2Up.x = pipe2Up.x - pipeMovement
	pipe2Down.x = pipe2Down.x - pipeMovement
	floorBlock.x = floorBlock.x - pipeMovement
	
	if floorBlock.x < 5 * display.contentWidth/12 then
		floorBlock.x = display.contentCenterX
	end
	
	if pipe1Up.x < -pipeWidth then
		createNewPipe(1)
	end
	
	if pipe2Up.x < -pipeWidth then
		createNewPipe(2)
	end
	
	if pipe1Up.x + pipeWidth < ab.x - abH and pipe1scoreAvailable then
		score = score + 1
		scorePoints.text = score
		scorePoints:toFront()
		pipe1scoreAvailable = false
		
		media.playSound('coin.mp3')
		if score == 1 then
			unlockAchievement('CgkImKWCu6UGEAIQAQ')
		end
		if score == 5 then
			unlockAchievement('CgkImKWCu6UGEAIQAg')
		end
		if score == 999 then
			unlockAchievement('CgkImKWCu6UGEAIQBQ')
		end
	end
	
	if pipe2Up.x + pipeWidth < ab.x - abH and pipe2scoreAvailable then
		score = score + 1
		scorePoints.text = score
		scorePoints:toFront()
		pipe2scoreAvailable = false
	
		media.playSound('coin.mp3')
		if score == 20 then
			unlockAchievement('CgkImKWCu6UGEAIQAw')
		end
		if score == 100 then
			unlockAchievement('CgkImKWCu6UGEAIQBA')
		end
	end
end

local function showLeaderboards()
	if ( system.getInfo("platformName") == "Android" ) then
		gameNetwork.show( "leaderboards" )
	else
		gameNetwork.show( "leaderboards", { leaderboard = {timeScope="AllTime"} } )
	end
	return true
end

local function showAchievements()
	gameNetwork.show("achievements")
	return true
end

local function retryScene()
	tryAgainButton.isVisible = true
	tryAgainText.isVisible = true
	tryAgainButton:addEventListener('touch',tryAgainButton)

	leaderboardButton.isVisible = true
	leaderboardText.isVisible = true
	leaderboardButton:addEventListener('touch',leaderboardButton)

	achievementButton.isVisible = true
	achievementText.isVisible = true
	achievementButton:addEventListener('touch',achievementButton)

	function leaderboardButton:touch (event)
		showLeaderboards()
	end

	function tryAgainButton:touch (event)
		--started = false
		--tryAgainButton:removeSelf()
		tryAgainButton:removeEventListener('touch',tryAgainButton)
		tryAgainButton.isVisible = false
		tryAgainText.isVisible = false
		--display.remove(tryAgainButton)
		--tryAgainButton = nil
		--leaderboardButton:removeSelf()
		leaderboardButton:removeEventListener('touch',leaderboardButton)
		leaderboardButton.isVisible = false
		leaderboardText.isVisible = false
		--display.remove(leaderboardButton)
		--leaderboardButton = nil
		--achievementButton:removeSelf()
		achievementButton:removeEventListener('touch',achievementButton)
		achievementButton.isVisible = false
		achievementText.isVisible = false
		--display.remove(achievementButton)
		--achievementButton = nil
		bg:addEventListener('touch', bg)
		retry = true
		--start()
	end

	function achievementButton:touch (event)
		showAchievements()
	end
end

local function scoreAnimation()
	if scoreText.isVisible then
		scoreText.text = 'Score: ' .. scoreAnimationTemp
	else
		scoreText.text = 'Score: ' .. scoreAnimationTemp
		scoreText.isVisible = true
		scoreText:toFront()
	end
	
	if scoreAnimationTemp > record then
		if recordText.isVisible then
			recordText.text = 'Record: ' .. scoreAnimationTemp
		else
			recordText.isVisible = true
			recordText.text = 'Record: ' .. scoreAnimationTemp
			recordText:toFront()
			--recordText = display.newText('Record: ' .. scoreAnimationTemp, display.contentCenterX, 5 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
			--recordText:setFillColor(0,0,0)
		end
	end
	scoreAnimationTemp = scoreAnimationTemp + 1
end

local function setNewRecord()
	newRecordText.isVisible = true
end


local function submitHighScore(highScore)
	gameNetwork.request("setHighScore",
		{
			localPlayerScore =
			{
				category='CgkImKWCu6UGEAIQBg',
				value=tonumber(highScore)
			}
		}
	)
end

local function setRecord(scoreT, recordT, newRecord)
	--recordText = display.newText('Record: ' .. recordT, display.contentCenterX, 5 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	--recordText:setFillColor(0,0,0)
	recordText.isVisible = true
	recordText.text = 'Record: ' .. recordT
	scoreAnimationTemp = 0
	
	if scoreT < 3 then
		timer.performWithDelay(500, scoreAnimation, scoreT + 1)
	else
		timer.performWithDelay(1500 / scoreT, scoreAnimation, scoreT + 1)
	end
	
	if newRecord then
		timer.performWithDelay(2000, setNewRecord)
		submitHighScore(scoreT)
	end
end

local function maxRecord()
	local filePath = system.pathForFile('recordFile.txt',system.DocumentsDirectory)
	local file, errorMessage = io.open(filePath, "r")
	
	if file then		
		local contents = file:read( "*a" )
		record = tonumber(contents)
		if score > record then
			io.close(file)
			file = io.open(filePath, 'w+')
			file:write(score)
			setRecord(score, record, true)
		else
			setRecord(score, record, false)
		end
	else
		file = io.open(filePath, 'w+')
		file:write(score)
		
		record = 0

		if score > 0 then
			setRecord(score, record, true)
		else
			setRecord(score, record, false)
		end
	end
	
	io.close(file)
end

local function gameOver()
	--audio.play(yellSound)
	media.playSound('yell.mp3')
	--media.stopSound()
	--audio.pause(bgmusicChannel)
	system.vibrate()
	lost = true
	scoreTitle.isVisible = false
	--scoreTitle = nil
	scorePoints.isVisible = false
	--scorePoints = nil
	--text = display.newText("Game over", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
	--text:setFillColor(0,0,0)
	gameOverText.isVisible = true
	timer.cancel(gravityTimer)
	timer.cancel(movePipesTimer)
	timer.cancel(checkCollisionTimer)
	ab.rotation = 90
	movementParams = {
		x = ab.x,
		y = 4 * display.contentHeight/5 - abH,
		time = 1000
	}
	transition.moveTo(ab, movementParams)
	transition.to(ab, {rotation = -90, time = 2000})
	--media.playEventSound('yell.mp3')
	--ab.rotation = -90
	timer.performWithDelay(2000, retryScene)
	maxRecord()
	bg:removeEventListener('touch', bg)
end

local function checkCollision (event)
	if (ab.y - abH < 0) or (ab.y  + abH > floorlevel) then -- piso y techo
		gameOver()
		return
	end
	
	if ab.x > (pipe1Down.x - pipeWidth - abH) and ab.x < (pipe1Down.x + pipeWidth + abH) then --tubo 1
		if (ab.y - abH) < pipe1rand or (ab.y + abH) > (pipe1rand + display.contentHeight/5) then 
			gameOver()
			return
		end
	end
	
	if ab.x > (pipe2Down.x - pipeWidth - abH) and ab.x < (pipe2Down.x + pipeWidth + abH) then --tubo 2
		if (ab.y - abH) < pipe2rand or (ab.y + abH) > (pipe2rand + display.contentHeight/5) then 
			gameOver()
			return
		end
	end
end

-- Called when the scene's view does not exist:
function scene:create( event )
	local sceneGroup = self.view

	--Runtime:addEventListener( "system", systemEvents )
	--gameNetwork.init( "google", gpgsInitCallback )
	gameNetworkSetup()
	start()
	
	function bg:touch(event)
		if event.phase == 'began' then
			if retry then
				started = false
				retry = false
				--tryAgain:removeSelf()
				--removeGarbage()
				restart()
				--showLeaderboards()
			else
				if started then
					vs = display.contentHeight/50;
					if not lost then
						--audio.play(flapSound)
						media.playSound('flap.mp3')
					end
				else
					started = true
					vs = display.contentHeight/50;
					movePipesTimer = timer.performWithDelay(fps, movePipes, -1)
					checkCollisionTimer = timer.performWithDelay(fps, checkCollision, -1)
					gravityTimer = timer.performWithDelay(fps, gravity, -1)
					--display.remove(tapToStart)
					--tapToStart:removeSelf()
					--tapToStart = nil
					tapToStart.isVisible = false
					if not lost then
					--audio.play(flapSound)
						media.playSound('flap.mp3')
					end
				end
			end
		end
	end
	
	bg:addEventListener('mouse', bg)
	bg:addEventListener('touch', bg)
end




function scene:show( event )
	local sceneGroup = self.view
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

local sceneGroup = self.view
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