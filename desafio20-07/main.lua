local physics = require ("physics")
physics.start ()
physics.setGravity (0,9.8)

physics.setDrawMode ("hybrid")

display.setStatusBar (display.HiddenStatusBar)

local bg = display.newImageRect ("imagens/fundo.jpg", 800*1.5, 600*1.5)
bg.x, bg.y = contentCenterX, contentCenterY

local sprite = graphics.newImageSheet ("imagens/
