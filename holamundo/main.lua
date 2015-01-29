-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
print ('hola mundo')

vs = 0
gvt = 6

bg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
bg:setFillColor(0,0,0)
--text = display.newText("HOLA MUNDO", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
ab = display.newImage('angrybird.gif')
ab:translate(display.contentCenterX, display.contentCenterY)

function bg:mouse(event)
	if event.isPrimaryButtonDown then
		--ab.y = ab.y - 150
		vs = 30
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


local pipeUp = display.newRect(display.contentWidth-50, 0, 50, 300)
pipeUp:setFillColor(0,1,0)

local pipeDown = display.newRect(display.contentWidth-50, display.contentHeight, 50, 300)
pipeDown:setFillColor(0,1,0)


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
	pipeUp.x = pipeUp.x - 5
	pipeDown.x = pipeDown.x - 5
end

local function checkCollision (event)
	if (ab.y < 0) or (ab.y > display.contentHeight) then
		text = display.newText("Game over", display.contentCenterX, display.contentCenterY, native.SystemFontBold, 20, 'left')
	end
end

timer.performWithDelay(50, gravity, -1)
timer.performWithDelay(50, movePipes, -1)
timer.performWithDelay(50, checkCollision, -1)

