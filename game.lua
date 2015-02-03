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
	retry = false
	
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
	pipe1Up:setFillColor(0,1,0)

	pipe1Down = display.newRect(1.5*display.contentWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
	pipe1Down:setFillColor(0,1,0)

	pipe2Up = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2upMid, 2 * pipeWidth, pipe2rand)
	pipe2Up:setFillColor(0,1,0)

	pipe2Down = display.newRect(display.contentWidth * 2 + pipeWidth, pipe2downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe2rand)
	pipe2Down:setFillColor(0,1,0)


	local floorBlock = display.newRect(display.contentCenterX, 9 * display.contentHeight/10, display.contentWidth, display.contentHeight/5)
	floorBlock:setFillColor(0,0,1)

	ab:toFront()
	scoreTitle:toFront()
	scorePoints:toFront()
end

start()

local function gravity (event)
	ab:translate(0,-vs)
	vs = vs - gvt
end

local function movePipes (event)
	pipe1Up.x = pipe1Up.x - pipeMovement
	pipe1Down.x = pipe1Down.x - pipeMovement
	pipe2Up.x = pipe2Up.x - pipeMovement
	pipe2Down.x = pipe2Down.x - pipeMovement
	
	if pipe1Up.x < -pipeWidth then
		
		pipe1Up:setFillColor(0,0,0)
		pipe1Down:setFillColor(0,0,0)
		
		pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe1upMid = pipe1rand / 2
		pipe1downMid = (display.contentHeight + pipe1rand) / 2
		
		--pipe1Up:translate(display.contentWidth + pipeWidth, pipe1upMid, 2 * pipeWidth, pipe1rand)
		pipe1Up = display.newRect(display.contentWidth + pipeWidth, pipe1upMid, 2 * pipeWidth, pipe1rand)
		pipe1Up:setFillColor(0,1,0)

		--pipe1Down:translate(display.contentWidth + pipeWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
		pipe1Down = display.newRect(display.contentWidth + pipeWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
		pipe1Down:setFillColor(0,1,0)
		
		ab:toFront()
		scoreTitle:toFront()
		scorePoints:toFront()
		
		pipe1scoreAvailable = true
	end
	
	if pipe2Up.x < -pipeWidth then
	
		pipe2Up:setFillColor(0,0,0)
		pipe2Down:setFillColor(0,0,0)
		
		pipe2rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe2upMid = pipe2rand / 2
		pipe2downMid = (display.contentHeight + pipe2rand) / 2
		
		pipe2Up = display.newRect(display.contentWidth + pipeWidth, pipe2upMid, 2 * pipeWidth, pipe2rand)
		pipe2Up:setFillColor(0,1,0)

		pipe2Down = display.newRect(display.contentWidth  + pipeWidth, pipe2downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe2rand)
		pipe2Down:setFillColor(0,1,0)
		
		ab:toFront()
		scoreTitle:toFront()
		scorePoints:toFront()
		
		pipe2scoreAvailable = true
	end
	
	if pipe1Up.x + pipeWidth < ab.x - abH and pipe1scoreAvailable then
		score = score + 1
		scorePoints.text = score
		scorePoints:toFront()
		pipe1scoreAvailable = false
	end
	
	if pipe2Up.x + pipeWidth < ab.x - abH and pipe2scoreAvailable then
		score = score + 1
		scorePoints.text = score
		scorePoints:toFront()
		pipe2scoreAvailable = false
	end
end

local function retryScene()
	retry = true
	tryAgain = display.newText("Tap to try again", display.contentCenterX, 7 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	tryAgain:setFillColor(0,0,0)
end

local function setRecord(scoreText, recordText, newRecord)
	scoreText = display.newText('Score: ' .. scoreText, display.contentCenterX, 4 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	scoreText:setFillColor(0,0,0)
	recordText = display.newText('Record: ' .. recordText, display.contentCenterX, 5 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
	recordText:setFillColor(0,0,0)
	
	if newRecord then 
		newRecordText = display.newText('NEW RECORD!' , display.contentCenterX, 3 * display.contentHeight/10, native.SystemFontBold, 20, 'left')
		newRecordText:setFillColor(0,0,0)
	end
end

local function maxRecord()
	local filePath = system.pathForFile('recordFile.txt',system.DocumentsDirectory)
	local file, errorMessage = io.open(filePath, "r")
	
	if file then		
		local contents = file:read( "*a" )
		local record = tonumber(contents)
		if score > record then
			print ('mas alto')
			print ('score: ' .. score .. ' record: ' .. record)
			io.close(file)
			file = io.open(filePath, 'w+')
			file:write(score)
			
			setRecord(score, score, true)
		else
			print ('no mas alto')
			print ('score: ' .. score .. ' record: ' .. record)
			
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
	scoreTitle:removeSelf()
	scorePoints:removeSelf()
	text = display.newText("Game over", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
	text:setFillColor(0,0,0)
	timer.pause(gravityTimer)
	timer.pause(movePipesTimer)
	timer.pause(checkCollisionTimer)
	--bg:removeEventListener('mouse', bg)
	--bg:removeEventListener('touch', bg)
	movementParams = {
		x = ab.x,
		y = 4 * display.contentHeight/5 - abH,
		time = 1000
	}
	transition.moveTo(ab, movementParams)
	timer.performWithDelay(2000, retryScene)
	maxRecord()
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

function bg:mouse(event)
	if event.isPrimaryButtonDown then
		if retry then
			started = false
			retry = false
			tryAgain:removeSelf()
			start()
		else
			if started then
				vs = display.contentHeight/50;
			else
				started = true
				vs = display.contentHeight/50;
				movePipesTimer = timer.performWithDelay(fps, movePipes, -1)
				checkCollisionTimer = timer.performWithDelay(fps, checkCollision, -1)
				gravityTimer = timer.performWithDelay(fps, gravity, -1)
				tapToStart:removeSelf()
			end
		end
	end
end

function bg:touch(event)
	if event.phase == 'began' then
		if retry then
			started = false
			retry = false
			tryAgain:removeSelf()
			start()
		else
			if started then
				vs = display.contentHeight/50;
			else
				started = true
				vs = display.contentHeight/50;
				movePipesTimer = timer.performWithDelay(fps, movePipes, -1)
				checkCollisionTimer = timer.performWithDelay(fps, checkCollision, -1)
				gravityTimer = timer.performWithDelay(fps, gravity, -1)
				tapToStart:removeSelf()
			end
		end
	end
end

bg:addEventListener('mouse', bg)
bg:addEventListener('touch', bg)


