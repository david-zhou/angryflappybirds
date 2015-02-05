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

Runtime:addEventListener( "system", systemEvents )

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
	
	bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
	bg:setFillColor(100,50,20)

	scoreTitle = display.newText("Score:", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
	scoreTitle:setFillColor(0,0,0)
	scoreTitle:toFront()

	scorePoints = display.newText(score, display.contentCenterX, display.contentHeight/5, native.SystemFontBold, 20, 'left')
	scorePoints:setFillColor(0,0,0)
	scorePoints:toFront()

	ab = display.newImage('angrybird.gif')
	ab:translate(display.contentWidth/4, 2*display.contentHeight/5)
	ab:scale((display.contentHeight/20)/imageH,((display.contentHeight/20)/imageH))
	ab:toFront()

	tapToStart = display.newText("Tap to start", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
	tapToStart:setFillColor(0,0,0)
	tapToStart:toFront()

	pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 2 * display.contentHeight/10
	pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10) -- 5 * display.contentHeight/10 

	pipe1upMid = pipe1rand / 2
	pipe1downMid = (display.contentHeight + pipe1rand) / 2 -- (4 * display.contentHeight / 5 + pipe1rand + display.contentHeight / 5) / 2 -- 
	pipe2upMid = pipe2rand / 2
	pipe2downMid = (display.contentHeight + pipe2rand) / 2

	pipe1Up = display.newRect(1.5*display.contentWidth, pipe1upMid, 2 * pipeWidth, pipe1rand)
	pipe1Up:setFillColor(36/255,227/255,59/255)

	pipe1Down = display.newRect(1.5*display.contentWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
	pipe1Down:setFillColor(36/255,227/255,59/255)

	pipe2Up = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2upMid, 2 * pipeWidth, pipe2rand)
	pipe2Up:setFillColor(36/255,227/255,59/255)

	pipe2Down = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe2rand)
	pipe2Down:setFillColor(36/255,227/255,59/255)


	local floorBlock = display.newRect(display.contentCenterX, 9 * display.contentHeight/10, display.contentWidth, display.contentHeight/5)
	floorBlock:setFillColor(163/255,152/255,100/255)
	
	--[[
	flapSound = audio.loadSound("flap.mp3")
	coinSound = audio.loadSound("coin_effect.mp3")
	yellSound = audio.loadSound("yell.mp3")
	--]]
	
	ab:toFront()
	scoreTitle:toFront()
	scorePoints:toFront()
end

start()

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
		
		pipe1upMid = pipe1rand / 2
		pipe1downMid = (display.contentHeight + pipe1rand) / 2
		
		pipe1Up.x = display.contentWidth + pipeWidth
		pipe1Up.y = pipe1upMid
		pipe1Up.height = pipe1rand

		pipe1Down.x = display.contentWidth + pipeWidth
		pipe1Down.y = pipe1downMid
		pipe1Down.height = 6 * display.contentHeight/10 - pipe1rand
		
		ab:toFront()
		scoreTitle:toFront()
		scorePoints:toFront()
		
		pipe1scoreAvailable = true
	else
		pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe2upMid = pipe2rand / 2
		pipe2downMid = (display.contentHeight + pipe2rand) / 2
		
		pipe2Up.x = display.contentWidth + pipeWidth
		pipe2Up.y = pipe2upMid
		pipe2Up.height = pipe2rand

		pipe2Down.x = display.contentWidth + pipeWidth
		pipe2Down.y = pipe2downMid
		pipe2Down.height = 6 * display.contentHeight/10 - pipe2rand
		
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
		--audio.play(coinSound)
		media.playSound('coin.mp3')
		if score == 1 then
			unlockAchievement('CgkIxY-DlLESEAIQAQ')
		end
		if score == 5 then
			unlockAchievement('CgkIxY-DlLESEAIQAg')
		end
		if score == 999 then
			unlockAchievement('CgkIxY-DlLESEAIQBQ')
		end
	end
	
	if pipe2Up.x + pipeWidth < ab.x - abH and pipe2scoreAvailable then
		score = score + 1
		scorePoints.text = score
		scorePoints:toFront()
		pipe2scoreAvailable = false
		--audio.play(coinSound)
		media.playSound('coin.mp3')
		if score == 20 then
			unlockAchievement('CgkIxY-DlLESEAIQAw')
		end
		if score == 100 then
			unlockAchievement('CgkIxY-DlLESEAIQBA')
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
	--tryAgain = display.newText("Tap to try again", display.contentCenterX, 7 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	--tryAgain:setFillColor(0,0,0)
	tryAgainButton = display.newRect(display.contentWidth/4, 13 * display.contentHeight/20, 3 * display.contentWidth/10, display.contentHeight/10)
	tryAgainButton:setFillColor(1,0,0)
	tryAgainButton:addEventListener('touch',tryAgainButton)
	leaderboardButton = display.newRect(3 * display.contentWidth/4, 13 * display.contentHeight/20, 3 * display.contentWidth/10, display.contentHeight/10)
	leaderboardButton:setFillColor(0,0,0)
	leaderboardButton:addEventListener('touch',leaderboardButton)
	achievementButton = display.newRect(display.contentWidth/2, 16 * display.contentHeight/20, 3 * display.contentWidth/10, display.contentHeight/10)
	achievementButton:setFillColor(0,0,1)
	achievementButton:addEventListener('touch',achievementButton)
	
	function leaderboardButton:touch (event)
		showLeaderboards()
	end
	
	function tryAgainButton:touch (event)
		--started = false
		tryAgainButton:removeSelf()
		leaderboardButton:removeSelf()
		achievementButton:removeSelf()
		bg:addEventListener('touch', bg)
		retry = true
		--start()
	end
	
	function achievementButton:touch (event)
		showAchievements()
	end
end

local function scoreAnimation()
	if scoreText then
		scoreText.text = 'Score: ' .. scoreAnimationTemp
	else
		scoreText = display.newText('Score: ' .. scoreAnimationTemp, display.contentCenterX, 4 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
		scoreText:setFillColor(0,0,0)
	end
	scoreText:toFront()
	
	if scoreAnimationTemp > record then
		if recordText then
			recordText.text = 'Record: ' .. scoreAnimationTemp
		else
			recordText = display.newText('Record: ' .. scoreAnimationTemp, display.contentCenterX, 5 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
			recordText:setFillColor(0,0,0)
		end
		
	end
	scoreAnimationTemp = scoreAnimationTemp + 1
end

local function setNewRecord()
	newRecordText = display.newText('NEW RECORD!' , display.contentCenterX, 3 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	newRecordText:setFillColor(1,140/255,0)
end

local function submitHighScore(highScore)
	gameNetwork.request("setHighScore",
		{
			localPlayerScore = 
			{ 
				category='CgkIxY-DlLESEAIQBg', 
				value=tonumber(highScore)
			}
		}
	)
end

local function setRecord(scoreT, recordT, newRecord)
	recordText = display.newText('Record: ' .. recordT, display.contentCenterX, 5 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	recordText:setFillColor(0,0,0)
	
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
		
		if score > 0 then
			setRecord(score, score, true)
		else
			setRecord(score, score, false)
		end
	end
	
	io.close(file)
end

local function gameOver()
	--audio.play(yellSound)
	media.playSound('yell.mp3')
	system.vibrate()
	lost = true
	scoreTitle:removeSelf()
	scorePoints:removeSelf()
	text = display.newText("Game over", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
	text:setFillColor(0,0,0)
	timer.pause(gravityTimer)
	timer.pause(movePipesTimer)
	timer.pause(checkCollisionTimer)
	ab.rotation = 90
	movementParams = {
		x = ab.x,
		y = 4 * display.contentHeight/5 - abH,
		time = 1000
	}
	transition.moveTo(ab, movementParams)
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

function bg:touch(event)
	if event.phase == 'began' then
		if retry then
			started = false
			retry = false
			--tryAgain:removeSelf()
			start()
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
				tapToStart:removeSelf()
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

--[[
local filePath = system.pathForFile('recordFile.txt',system.DocumentsDirectory)
local file, errorMessage = io.open(filePath, "w+")
file:write('0')
io.close(file)
--]]
