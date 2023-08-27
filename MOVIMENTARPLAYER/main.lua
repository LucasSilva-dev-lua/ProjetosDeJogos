local bg = display.newImageRect ("imagens/sky.png", 960*3, 240*3)
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local chao = display.newImageRect ("imagens/ground.png", 1028, 256)
chao.x = display.contentCenterX
chao.y = 440

local player = display.newImageRect ("imagens/player.png", 532/3, 469/3)
player.x = 50
player.y = 250

-- Andar para a direita
local function direita ()
    player.x = player.x + 15
end

local botaoDireita = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoDireita.x = 320
botaoDireita.y = 380
botaoDireita:addEventListener ("tap", direita)

local function esquerda ()
    player.x = player.x - 15
end

local botaoEsquerda = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoEsquerda.x = 170
botaoEsquerda.y = 380
botaoEsquerda.rotation = 180
botaoEsquerda:addEventListener ("tap", esquerda)

local function cima ()
    player.y = player.y - 15
end

local botaoCima = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoCima.x = 240
botaoCima.y = 310
botaoCima.rotation = 270
botaoCima:addEventListener ("tap", cima)

local function baixo ()
    player.y = player.y + 15
end

local botaoBaixo = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoBaixo.x = 240
botaoBaixo.y = 460
botaoBaixo.rotation = 90
botaoBaixo:addEventListener ("tap", baixo)

local function cimadireita ()
    player.y = player.y - 15
    player.x = player.x + 15
end

local botaoCimaDireita = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoCimaDireita.x = 300
botaoCimaDireita.y = 320
botaoCimaDireita.rotation = 315
botaoCimaDireita:addEventListener ("tap", cimadireita)

local function baixodireita ()
    player.y = player.y + 15
    player.x = player.x + 15
end

local botaoBaixoDireita = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoBaixoDireita.x = 300
botaoBaixoDireita.y = 440
botaoBaixoDireita.rotation = 45
botaoBaixoDireita:addEventListener("tap", baixodireita)

local function cimaesquerda ()
    player.y = player.y - 15
    player.x = player.x - 15
end

local botaoCimaEsquerda = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoCimaEsquerda.x = 180
botaoCimaEsquerda.y = 320
botaoCimaEsquerda.rotation = 225
botaoCimaEsquerda:addEventListener ("tap", cimaesquerda)

local function baixoesquerda ()
    player.y = player.y + 15
    player.x = player.x - 15
end

local botaoBaixoEsquerda = display.newImageRect ("imagens/button.png", 1280/20, 1279/20)
botaoBaixoEsquerda.x = 180
botaoBaixoEsquerda.y = 440
botaoBaixoEsquerda.rotation = 135
botaoBaixoEsquerda:addEventListener ("tap", baixoesquerda)