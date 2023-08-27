-- Criando grupos de exibição

local backGroup = display.newGroup () -- Back usado para plano de fundo, decorações que não terão interação com o jogo.
local mainGroup = display.newGroup () -- Usado para os objetos que terão dentro do jogo, grupo principal.
local uiGroup = display.newGroup () -- Utilizado para placar, vidas, texto, que ficarão na frenete do jogo porém sem interação.

-- Método embutido:
-- Inclui o objeto no grupo já na sua criação.
local bg = display.newImageRect (backGroup, "imagens/bg.jpg", 509*2, 339*2)
bg.x = display.contentCenterX   
bg.y = display.contentCenterY

-- Método direto:
-- Incluir o objeto depois da sua criação.
local chao = display.newImageRect ("imagens/chao.png", 4503/5, 613/5)
chao.x = display.contentCenterX
chao.y = 430
mainGroup:insert (chao)

local sun = display.newImageRect (backGroup, "imagens/sun.png", 256, 256)
sun.x = 30
sun.y = 40

local cloud = display.newImageRect ("imagens/cloud.png", 2360/6, 984/6)
cloud.x = 200
cloud.y = 50
backGroup:insert(cloud)

local arvore = display.newImageRect (mainGroup, "imagens/tree.png", 1024/5, 1024/5)
arvore.x = 50
arvore.y = 320

local arvore2 = display.newImageRect ("imagens/tree.png", 1024/5, 1024/5)
arvore2.x = 300
arvore2.y = 320
mainGroup:insert(arvore2)

chao:toFront()