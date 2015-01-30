print ('hola mundo')

vs = 0
gvt = 2.4
floorlevel = 4 * display.contentHeight/5
imageH = 50
imageW = 50
pipeWidth = display.contentWidth/12
fps = 20

abH = display.contentHeight/40


bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
bg:setFillColor(100,50,20)

score = display.newText("Score:", display.contentCenterX, display.contentHeight/10, native.SystemFontBold, 20, 'left')
score:setFillColor(0,0,0)
score:toFront()

ab = display.newImage('angrybird.gif')
ab:translate(display.contentWidth/4, display.contentCenterY)
ab:scale((display.contentHeight/20)/imageH,((display.contentHeight/20)/imageH))
ab:toFront()

function bg:mouse(event)
	if event.isPrimaryButtonDown then
		--ab.y = ab.y - 150
		vs = display.contentHeight/20;
		--[[
		local newY = ab.y - 150
		local movementParams = {
			x = ab.x,
			y = newY,
			time = 40
		}
		transition.moveTo(ab, movementParams)
		--]]
	end
end

function bg:touch(event)
	if event.phase == 'began' then
		--ab.y = ab.y - 150
		vs = display.contentHeight/20;
		--[[
		local newY = ab.y - 150
		local movementParams = {
			x = ab.x,
			y = newY,
			time = 40
		}
		transition.moveTo(ab, movementParams)
		--]]
	end
end

bg:addEventListener('mouse', bg)
bg:addEventListener('touch', bg)

--[[
local pointA = display.newRect(display.contentCenterX, display.contentCenterY/4, 1,1)
local pointB = display.newRect(display.contentCenterX, 3 * display.contentCenterY/4, 1,1)

local movementParams = {
x = display.contentCenterX,
y = display.contentCenterY/4,
time = 2000
}

transition.moveTo(text, movementParams)
--]]


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
score:toFront()

local function gravity (event)
	--ab.y += vs
	movementParams = {
		x = ab.x,
		y = ab.y - vs,
		time = 50
	}
	transition.moveTo(ab, movementParams)
	vs = vs - gvt
	--ab.y = ab.y + 8
end

local function movePipes (event)
	pipe1Up.x = pipe1Up.x - 5
	pipe1Down.x = pipe1Down.x - 5
	pipe2Up.x = pipe2Up.x - 5
	pipe2Down.x = pipe2Down.x - 5
	
	if pipe1Up.x < -pipeWidth then
		
		pipe1Up:setFillColor(0,0,0)
		pipe1Down:setFillColor(0,0,0)
		
		pipe1rand = math.random(display.contentHeight/10, 5 *display.contentHeight/10)
		
		pipe1upMid = pipe1rand / 2
		pipe1downMid = (display.contentHeight + pipe1rand) / 2
		
		pipe1Up = display.newRect(display.contentWidth + pipeWidth, pipe1upMid, 2 * pipeWidth, pipe1rand)
		pipe1Up:setFillColor(0,1,0)

		pipe1Down = display.newRect(display.contentWidth + pipeWidth, pipe1downMid, 2 * pipeWidth, 6 * display.contentHeight/10 - pipe1rand)
		pipe1Down:setFillColor(0,1,0)
		
		ab:toFront()
		score:toFront()
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
		score:toFront()
	end
end

local function createNewPipe ()
	
end

local function checkCollision (event)
	if (ab.y - abH < 0) or (ab.y  + abH > floorlevel) then
		text = display.newText("Game over", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
		text:setFillColor(0,0,0)
		timer.pause(gravityTimer)
		timer.pause(movePipesTimer)
		timer.pause(checkCollisionTimer)
		bg:removeEventListener('mouse', bg)
		bg:removeEventListener('touch', bg)
		movementParams = {
			x = ab.x,
			y = 4 * display.contentHeight/5,
			time = 1000
		}
		transition.moveTo(ab, movementParams)
		return
	end
	
	if ab.x > (pipe1Down.x - pipeWidth - abH) and ab.x < (pipe1Down.x + pipeWidth + abH) then
		if (ab.y - abH) < pipe1rand or (ab.y + abH) > (pipe1rand + display.contentHeight/5) then 
			text = display.newText("Game over", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
			text:setFillColor(0,0,0)
			timer.pause(gravityTimer)
			timer.pause(movePipesTimer)
			timer.pause(checkCollisionTimer)
			bg:removeEventListener('mouse', bg)
			bg:removeEventListener('touch', bg)
			movementParams = {
				x = ab.x,
				y = 4 * display.contentHeight/5,
				time = 1000
			}
			transition.moveTo(ab, movementParams)
			return
		end
	end
	
	if ab.x > (pipe2Down.x - pipeWidth - abH) and ab.x < (pipe2Down.x + pipeWidth + abH) then
		if (ab.y - abH) < pipe2rand or (ab.y + abH) > (pipe2rand + display.contentHeight/5) then 
			text = display.newText("Game over", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
			text:setFillColor(0,0,0)
			timer.pause(gravityTimer)
			timer.pause(movePipesTimer)
			timer.pause(checkCollisionTimer)
			bg:removeEventListener('mouse', bg)
			bg:removeEventListener('touch', bg)
			movementParams = {
				x = ab.x,
				y = 4 * display.contentHeight/5,
				time = 1000
			}
			transition.moveTo(ab, movementParams)
			return
		end
	end
end

movePipesTimer = timer.performWithDelay(fps, movePipes, -1)
checkCollisionTimer = timer.performWithDelay(fps, checkCollision, -1)
gravityTimer = timer.performWithDelay(fps, gravity, -1)