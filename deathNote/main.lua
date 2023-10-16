--Chamar a biblioteca de fisica
local physics = require ("physics")
--Iniciar o  motor de física
physics.start ()
--Definir a gravidade.
physics.setGravity (0,0)
--definir o modo de renderização
physics.setDrawMode ("normal") -- normal, hybrid, debug

--Remover a barra de notificações.
display.setStatusBar (display.HiddenStatusBar)

--Criar os grupos de exibição.
local grupoBg = display.newGroup() -- Objetos decorativos, cenário (não tem interação)
local grupoMain = display.newGroup() -- Bloco principal (tudo que precisar interagir com o player fica nesse grupo)
local grupoUI = display.newGroup() -- Interface que fica a frente do player e que não tem interação com o grupo Main.

local bg = display.newImageRect (grupoBg, "imagens/quartodolight.jpg", 529, 355)
bg.x, bg.y = display.contentCenterX, display.contentCenterY

local light = display.newImageRect (grupoMain, "imagens/lightyagamiwithapple.png", 236/1.2, 310/1.2)
light.x, light.y = 100, 220
light.myName = "Light"

local ryuk = display.newImageRect (grupoMain, "imagens/ryuk.png", 576/1.5, 433/1.4)
ryuk.x, ryuk.y = 370, 190
ryuk.myName = "Ryuk"

-- Criar um novo texto:
local parametros = {
    text = "Ryuk:",
    x = 200,
    y = 200,
    font = "Arial",
    fontSize = 20,
    align = "right"
}
local nome = display.newText (parametros)

nome:setFillColor (1, 0, 0)

local parametros1 = {
    text = "Ei Light, o que vai fazer ?",
    x = 210,
    y = 200,
    font = "Arial",
    fontSize = 20,
    aligh = "right"
}
local nome1 = display.newText (parametros1)
