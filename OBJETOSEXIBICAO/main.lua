-- Adicionar nova imagem na tela:
-- Comandos: display.newImageRect ("pasta/arquivo.formato", largura, altura)
local bg = display.newImageRect ("imagens/bg.jpg", 1280*1.25, 720*1.25) -- Definir localização do objeto.
-- Comando: variável.linha que vou definir = localização na linha.
bg.x = display.contentCenterX -- Comando que centraliza a variável em qualquer resolução. x (horizontal)
bg.y = display.contentCenterY -- y (vertical)

local pikachu = display.newImageRect ("imagens/pikachu.png", 1191/5, 1254/5)
pikachu.x = display.contentCenterX
pikachu.y = display.contentCenterY
pikachu.x = 470
pikachu.y = 550

local charmander = display.newImageRect ("imagens/charmander.png", 507/2, 492/2)
charmander.x = 500
charmander.y = 240
--------------------------------------------------------------------------------------------------------------------------

-- Criando um retângulo:
-- Comandos: diplay.newRect (localização x, localização y, largura, altura)
local retangulo = display.newRect (750, 380, 100, 70)

-- Criando um círculo:
-- Comandos: display.newCircle (x, y, radius (raio (metade do círculo)) )
local circulo = display.newCircle (150, 80, 50)

local mystery = display.newImageRect ("imagens/mystery.png", 493/2, 506/2)
mystery.x = 720
mystery.y = 380

local pokeball = display.newImageRect ("imagens/pokeball.png", 2109/5, 1482/5)
pokeball.x = 220
pokeball.y = 120