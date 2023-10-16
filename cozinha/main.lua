--Chamar a biblioteca de fisica
local physics = require ("physics")
--Iniciar o  motor de física
physics.start ()
--Definir a gravidade.
physics.setGravity (0,0)
--definir o modo de renderização
physics.setDrawMode ("hybrid") -- normal, hybrid, debug

--Remover a barra de notificações.
display.setStatusBar (display.HiddenStatusBar)

letterboxWidth = (display.actualContentWidth-display.contentWidth)/2
letterboxHeight = (display.actualContentHeight-display.contentHeight)/2

--Criar os grupos de exibição.
local grupoBg = display.newGroup() -- Objetos decorativos, cenário (não tem interação)
local grupoMain = display.newGroup() -- Bloco principal (tudo que precisar interagir com o player fica nesse grupo)
local grupoUI = display.newGroup() -- Interface que fica a frente do player e que não tem interação com o grupo Main.

-- Fundo
local bg = display.newImageRect (grupoBg, "imagens/cozinha_fundo.png", 480, 320)
bg.x, bg.y = display.contentCenterX, display.contentCenterY

local ferramentas = display.newImageRect (grupoMain, "imagens/ferramentas.png", 64, 272)
ferramentas.x = -138 + display.contentWidth + letterboxWidth
ferramentas.y = display.contentCenterY + 8

local pedidos = display.newImageRect (grupoUI, "imagens/cozinha_pedidos.png", 272, 64)
pedidos.x = display.contentCenterX - 104
pedidos.y = display.screenOriginY + 32

local bancada = display.newImageRect (grupoMain, "imagens/cozinha_Bancada.png", 480, 48)
bancada.x = display.contentCenterX
bancada.y = display.contentCenterY + 25
bancada:toBack ()

local pratos = display.newImageRect (grupoMain, "imagens/cozinha_Pilha_Pratos.png", 48, 96)
pratos.x = display.contentCenterX +136
pratos.y = display.contentCenterY +97

local pia = display.newImageRect (grupoMain, "imagens/cozinha_pia.png", 96, 48)
pia.x = display.contentCenterX +64
pia.y = display.contentCenterY +73

local tabua = display.newImageRect (grupoMain, "imagens/cozinha_Taboa.png", 96, 48)
tabua.x = display.contentCenterX +64
tabua.y = display.contentCenterY +121

local fogao = display.newImageRect (grupoMain, "imagens/cozinha_fogao.png", 96, 96)
fogao.x = display.contentCenterX -31
fogao.y = display.contentCenterY +97

local geladeira = display.newImageRect (grupoMain, "imagens/cozinha_geladeira.png", 144, 96)
geladeira.x = display.contentCenterX -151
geladeira.y = display.contentCenterY +97

-- pessoa na direita
local pessoaDi = display.newImageRect (grupoMain, "imagens/cozinha_Pessoa.png", 80, 96)
pessoaDi.x = display.contentCenterX +120
pessoaDi.y = display.contentCenterY -47

-- pessoa no meio na direita
local pessoaMeioDi = display.newImageRect (grupoMain, "imagens/cozinha_Pessoa.png", 80, 96)
pessoaMeioDi.x = display.contentCenterX +25
pessoaMeioDi.y = display.contentCenterY -47

-- pessoa no meio na esquerda
local pessoaMeioEsq = display.newImageRect (grupoMain, "imagens/cozinha_Pessoa.png", 80, 96)
pessoaMeioEsq.x = display.contentCenterX -70
pessoaMeioEsq.y = display.contentCenterY -47

-- pessoa na esquerda
local pessoaEsq = display.newImageRect (grupoMain, "imagens/cozinha_Pessoa.png", 80, 96)
pessoaEsq.x = display.contentCenterX -165
pessoaEsq.y = display.contentCenterY -47

-- sprite
local sprite = graphics.newImageSheet ("imagens/Sprite_Teste.png", {width=48, height=48, numFrames=4})

local spriteAnimacao = {
    -- {nome="estágio da animação", frameInicial=, continuação=, tempo=, loopins=(0 é infinito)}
        {name="Sprite", start=1, count=4, time=1000, loopCount=0}
}

local quadradinho = display.newSprite (sprite, spriteAnimacao)
quadradinho.x, quadradinho.y = display.contentCenterX, display.contentCenterY
quadradinho:setSequence ("Sprite")
quadradinho:play ()