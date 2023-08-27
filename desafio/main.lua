local bg = display.newImageRect ("imagens/vila.jpg", 1280/2, 720/2)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local physics = require ("physics")
physics.start ()
physics.setGravity (2, 9.8)
physics.setDrawMode ("hybrid")

display.setStatusBar (display.HiddenStatusBar)

local cima = display.newRect (display.contentCenterX, 0, 500, 50)
physics.addBody (cima, "static")
cima.myName = "teto"

local baixo = display.newRect (display.contentCenterX, 480, 500, 50)
physics.addBody (baixo, "static")
baixo.myName = "chão"

local esquerda = display.newRect (-15, display.contentCenterY, 50, 500)
physics.addBody (esquerda, "static")
esquerda.myName = "Parede esquerda"

local direita = display.newRect (330, display.contentCenterY, 50, 500)
physics.addBody (direita, "static")
direita.myName = "Parede direita"

local kiko = display.newImageRect ("imagens/kiko.jpg", 750/5, 557/5)
kiko.x = display.contentCenterX
kiko.y = display.contentCenterY
physics.addBody (kiko, {bounce=0.8})
kiko.myName = "Kiko"

local bola = display.newCircle (80, 50, 30)
bola:setFillColor (0.5, 0.9, 0.3)
physics.addBody (bola, {bounce=0.8, radius=48})
bola.myName = "bola"

physics.addBody (bola, "dynamic")
physics.addBody (kiko, "dynamic")

local function colisaoLocal (event)
    
        if (event.phase == "began" ) then
            bola:setFillColor (0.3, 0.8)
            print ("Algo colidiu!")
    
        else
            
            print ("Fim da colisão")
        end
    end
    
    bola:addEventListener ("collision", colisaoLocal)