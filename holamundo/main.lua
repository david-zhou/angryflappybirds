-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here
print ('La wea mágica, dude')

vs = 0
gvt = 6

local audio1 = audio.loadSound( "sfx_wing.ogg" )

local screen_adjustment = 1
local bg = display.newImage("Background.jpg", true)
bg.xScale = (screen_adjustment  * bg.contentWidth)/bg.contentWidth
bg.yScale = bg.xScale
bg.x = display.contentWidth / 2
bg.y = display.contentHeight / 2
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
		}sfx_wing.ogg
		transition.moveTo(ab, movementParams)
		--]]
		local audio1Channel = audio.play( audio1 )
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


local gradient = {
    type="gradient",
    color1={ 1, 1, 1 }, 
    color2={ 0, 0, 0 }, 
    direction="down"
}

local pipeUp = display.newRect(display.contentWidth-50, 0, 50, 300)
pipeUp:setFillColor(gradient)

gradient.direction="down"

local pipeDown = display.newRect(display.contentWidth-50, display.contentHeight, 50, 300)
pipeDown:setFillColor(gradient)


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

