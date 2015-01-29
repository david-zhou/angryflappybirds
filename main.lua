bg = display.newImage('bg.jpg')
--Fonts
--[[Gargle = Font.load("gargle.ttf")
Gargle:setPixelSizes(14,14)
GargleIt = Font.load("gargleit.ttf")
GargleIt:setPixelSizes(14,14)
]]
--Title
ttl = display.newImage('title.png')
ttl:translate(display.contentCenterX, 60)
ttl2 = display.newImage('title2.png')
ttl2:translate(display.contentCenterX+2,56)
--Sprite
ab = display.newImage('angrybird.gif')
ab:translate(display.contentCenterX,170)
ab:scale(1.5,1.5)
--Rate
rt = display.newText("RATE", display.contentCenterX, 250, "GargleCdRg-Regular", 40)