local physics = require ("physics")
physics.start ()
physics.setGravity (0, 0)
physics.setDrawMode ("normal")

display.setStatusBar (display.HiddenStatusBar)

local grupoBg = display.newGroup()
local grupoMain = display.newGroup()
local grupoUI = display.newGroup()

local pontos = 0
local vidas = 5

local mordor = display.newImageRect (grupoBg, "imagens/mordor.jpg", 800/1.7, 420/1.5)
mordor.x = display.contentCenterX
mordor.y = display.contentCenterY

local pontosText = display.newText (grupoUI, "Pontos: " ..pontos, 100, -5, native.systemFont, 20)

pontosText:setFillColor (0.5, 0.5, 0)

local vidasText = display.newText (grupoUI, "Vidas: " ..vidas, 250, -5, native.systemFont, 20)
vidasText:setFillColor (0.5, 0.9, 0)

local gollum = display.newImageRect (grupoMain, "imagens/gollum.png", 400/6, 589/6)
gollum.x = 50
gollum.y = 270
gollum.myName = "Gollum"
physics.addBody (gollum, "kynematic")

local botaoCima = display.newImageRect (grupoMain, "imagens/button.png", 1280/45, 1279/45)
botaoCima.x = 80
botaoCima.y = 320
botaoCima.rotation = -90

local botaoDiagonalDireita = display.newImageRect (grupoMain, "imagens/button.png", 1280/45, 1279/45)
botaoDiagonalDireita.x = 110
botaoDiagonalDireita.y = 320
botaoDiagonalDireita.rotation = -45

local botaoDireita = display.newImageRect (grupoMain, "imagens/button.png", 1280/45, 1279/45)
botaoDireita.x = 140
botaoDireita.y = 320

local botaoEsquerda = display.newImageRect (grupoMain, "imagens/button.png", 1280/45, 1279/45)
botaoEsquerda.x = 20
botaoEsquerda.y = 320
botaoEsquerda.rotation = 180

local botaoDiagonalEsquerda = display.newImageRect (grupoMain, "imagens/button.png", 1280/45, 1279/45)
botaoDiagonalEsquerda.x = 50
botaoDiagonalEsquerda.y = 320
botaoDiagonalEsquerda.rotation = -135

local function cima ()
    gollum.y = gollum.y - 10
end

local function dDireita ()
    gollum.y = gollum.y -10
    gollum.x = gollum.x + 10
end

local function direita () 
    gollum.x = gollum.x + 10
end

local function dEsquerda ()
    gollum.y = gollum.y - 10
    gollum.x = gollum.x - 10
end

local function esquerda ()
    gollum.x = gollum.x - 10
end

botaoCima:addEventListener ("tap", cima)
botaoDireita:addEventListener ("tap", direita)
botaoEsquerda:addEventListener ("tap", esquerda)
botaoDiagonalDireita:addEventListener ("tap", dDireita)
botaoDiagonalEsquerda:addEventListener ("tap", dEsquerda)

local frodo = display.newImageRect (grupoMain, "imagens/frodo.png", 190/3, 515/3)
frodo.x = 420
frodo.y = 230
frodo.myName = "Frodo"
physics.addBody (frodo, "dynamic")

local retanguloBaixo = display.newRect (display.contentCenterX, 300, 470, 1)
retanguloBaixo: setFillColor (0, 0, 0)
physics.addBody (retanguloBaixo, "kinematic")
retanguloBaixo: toBack ()

local retanguloEsquerda = display.newRect (5, display.contentCenterY, 1, 280)
retanguloEsquerda: setFillColor (0, 0, 0)
physics.addBody (retanguloEsquerda, "kinematic")
retanguloEsquerda: toBack ()

local retanguloDireita = display.newRect (475, display.contentCenterY, 1, 280)
retanguloDireita: setFillColor (0, 0, 0)
physics.addBody (retanguloDireita, "kinematic")
retanguloDireita: toBack ()

local retanguloCima = display.newRect (display.contentCenterX, 20, 470, 1)
retanguloCima: setFillColor (0, 0, 0)
physics.addBody (retanguloCima, "kinematic")
retanguloCima: toBack ()

local botaoTiro = display.newImageRect (grupoMain, "imagens/tiro.png", 260/9, 261/9)
botaoTiro.x = 170
botaoTiro.y = 321

local function atirar ()

    local pedra = display.newImageRect (grupoMain, "imagens/rock.png", 500/17, 500/17)

    pedra.x = gollum.x + 85
    pedra.y = gollum.y - 10
    physics.addBody (pedra, "kinematic", {isSensor=true})
    transition.to (pedra, {x=380, time=1000,

                    onComplete = function ()

                        display.remove (pedra)
                    end})
    pedra.myName = "Pedra"
    pedra:toBack ()
end

botaoTiro:addEventListener ("tap", atirar)

local anel = display.newImageRect (grupoMain, "imagens/anel.png", 256/10, 256/10) 
anel.x = 50 
anel.y = 170 
anel.myName =  "Anel"
physics.addBody (anel, "kynematic")

