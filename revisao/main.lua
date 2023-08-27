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

--Criar variaveis de pontos e vidas para atribuçao de valor.
local pontos = 0
local vidas = 5

-- Adicionar background
--                              (grupo, "pasta/nome do arquivo.formato", largura, altura)
local bg = display.newImageRect (grupoBg, "imagens/cidade2.jpg", 1920/2.4, 1200/1.1)
bg.x = display.contentCenterX -- Localização horizontal
bg.y = display.contentCenterY -- Localização vertical

-- Adicionar som de fundo
local audioBg = audio.loadStream ("Audio/sombg.mp3")
-- Reservando um canal de audio para o som de fundo
audio.reserveChannels (1)
-- Especificar o volume desse canal
audio.setVolume (0.6, {channel=1})
-- Reproduzir o audio
--         (audio a reproduzir, {canal, loopins (-1 infinito)})
audio.play (audioBg, {channel=1, loops=-1})

--Adicionar placar na tela.
-- (grupo, "Escreve o que irá aparecer na tela", concatenação para unir(os dois pontos finais " .. "), localizaçãoX, localizaçãoY, fonte, tamanho da fonte)
local pontosText = display.newText (grupoUI, "Spider pontos: " ..pontos, 210, 30, native.systemFont, 20)

pontosText:setFillColor (0, 0, 0.9)

local vidasText = display.newText (grupoUI, "Spider vidas: " ..vidas, 400, 30, native.systemFont, 20)
vidasText:setFillColor (0.9, 0, 0)

-- Adicionar herói
local aranha = display.newImageRect (grupoMain, "imagens/Homem-Aranha.png", 478/2.5, 375/2.5)
aranha.x = 160
aranha.y = 180
aranha.myName = "Homem Aranha"
-- Adicionar corpo físico a imagem.
physics.addBody (aranha, "kinematic") -- colide apenas com dinâmico e não tem interferência da gravidade.

-- Criar botões
local botaoCima = display.newImageRect (grupoMain, "imagens/seta.png", 470/5, 470/5)
botaoCima.x = 310
botaoCima.y = 980
botaoCima.rotation = -90 -- faz a rotação da imagem em x graus.

local botaoBaixo = display.newImageRect (grupoMain, "imagens/seta.png", 470/5, 470/5)
botaoBaixo.x = display.contentCenterX
botaoBaixo.y = 990
botaoBaixo.rotation = 90

-- Adicionar funções de movimentação
local function cima ()
    aranha.y = aranha.y - 20
end

local function baixo ()
    aranha.y = aranha.y + 20
end

-- Adicionar o ouvinte e a função ao botão.
botaoCima:addEventListener ("tap", cima)
botaoBaixo:addEventListener ("tap", baixo)

-- Adicionar botão de tiro:
local botaoTiro = display.newImageRect (grupoMain, "imagens/botaodetiro.png", 500/7, 500/7)
botaoTiro.x = 460
botaoTiro.y = 980

-- Função para atirar:
local function teiaAtirar ()
    -- Toda vez que a função for executada cria-se um novo "tiro"
    local teiaAranha = display.newImageRect (grupoMain, "imagens/teia1.png", 300/7, 300/7)
    -- A localização é a mesma do player
    teiaAranha.x = aranha.x + 85
    teiaAranha.y = aranha.y - 10
    physics.addBody (teiaAranha, "dynamic", {isSensor=true}) -- Determinamos que o projétil é um sensor, o que ativa a detecção contínua de colisão.
    transition.to (teiaAranha, {x=768, time=1000,
    -- Quando a transição for completa
                    onComplete = function ()
    -- Removemos o projétil do display.
                        display.remove (teiaAranha)
                    end})
                    -- som do tiro da teia
                    local audioTeia = audio.loadSound ("Audio/somdateia.mp3")
                    audio.play (audioTeia)
    teiaAranha.myName = "Teia"
    teiaAranha:toBack ()
end

botaoTiro:addEventListener ("tap", teiaAtirar)

-- Adicionar inimigo
local duende = display.newImageRect (grupoMain, "imagens/DuendeVerde.png", 478/2.5, 471/2.5)
duende.x = 670
duende.y = 180
duende.myName = "Duende Verde"
physics.addBody (duende, "kinematic")
local direcaoDuende = "cima"

-- Função para inimigo atirar:
local function duendeAtirar ()
    local bomba = display.newImageRect (grupoMain, "imagens/Bomba abóbora.png", 440/14, 440/14)
    bomba.x = duende.x - 90
    bomba.y = duende.y - 10
    bomba.rotation = 180
    physics.addBody (bomba, "dynamic", {isSensor=true})
    transition.to (bomba, {x=-200, time=1000,
                    onComplete = function ()
                        display.remove (bomba)
                    end})
    bomba.myName = "Bomba abóbora"
end

-- Criando o timer de disparo o inimigo:
-- Comandos timer: (tempo repetição, função, quantidade de repetições)
duende.timer = timer.performWithDelay (math.random (1000, 1500), duendeAtirar, 0)

-- Movimentação do inimigo:
local function movimentarDuende ()
-- Se a localizaçãox não for igual a nulo então
    if not (duende.x == nil ) then
-- Quando a direção do inimigo for cima então
        if (direcaoDuende == "cima" ) then
            duende.y = duende.y - 2
-- Se a localização y do inimigo for menor ou igual a 50 então
            if (duende.y <= 160 ) then
            -- Altera a variável para "baixo"
                direcaoDuende = "baixo"
            end -- if (duende.y.....)
-- Se a direção do inimigo for igual a baixo então
        elseif (direcaoDuende == "baixo" ) then
            duende.y = duende.y + 2
-- Se a localização do y do inimigo for maior ou igual a 400 então
            if (duende.y >= 850 ) then
                direcaoDuende = "cima"
            end -- if (duende.y.....)
        end -- if (direcaoDuende.....)
-- Se não
    else
        print ("Duende morreu!")
-- Runtime: representa todo o jogo (evento é executado para todos), enterframe: está ligado ao valor de FPS do jogo (frames por segundo), no caso, a função vai ser executada 60 vezes por segundo.
        Runtime:removeEventListener ("enterFrame", movimentarDuende)
    end
end

Runtime:addEventListener ("enterFrame", movimentarDuende)

-- Função de colisão:
local function onCollision (event)
-- Quando a fase de evento for began então
    if (event.phase == "began") then
-- Variáveis criadas para facilitar a escrita do código.
        local obj1 = event.object1
        local obj2 = event.object2
-- Quando o myName do objeto 1 for ... e o nome do obj2 for ...
        if ((obj1.myName == "Teia" and obj2.myName == "Duende Verde") or (obj1.myName == "Duende Verde" and obj2.myName == "Teia")) then
        -- Se o obj1 for ... then
            if (obj1.myName == "Teia") then
        -- Remove a Bomba abóbora.
                display.remove (obj1)
            else
                display.remove (obj2)
            end
-- Somar 10 pontos a cada colisão
            pontos = pontos + 10
-- Atualizo os pontos na tela.
            pontosText.text = "Spider pontos:" ..pontos
-- Se obj1 for aranha e o 2 for Bomba abóbora ou vice versa então

        elseif ((obj1.myName == "Homem Aranha" and obj2.myName == "Bomba abóbora") or (obj1.myName == "Bomba abóbora" and obj2.myName == "Homem Aranha")) then
            if (obj1.myName == "Bomba abóbora") then
                display.remove (obj1)
            else
                display.remove (obj2)
            end
            local audioBomba = audio.loadSound ("Audio/audiobombaduende.mp3")
                    audio.play (audioBomba)
-- Reduz uma vida do aranha a cada colisão
        vidas = vidas - 1
        vidasText.text = "Spider vidas:" ..vidas
            if (vidas <= 0) then
                audio.pause (audioBg)
                local risada = audio.loadSound ("Audio/risadadoduende.mp3")
                audio.play (risada)
                Runtime:removeEventListener ("collision", onCollision)
                Runtime:removeEventListener ("enterFrame", movimentarDuende)
                timer.pause (duende.timer) -- Colocar sempre o nome que foi criado o timerWithDelay
                botaoBaixo:removeEventListener ("tap", baixo)
                botaoCima:removeEventListener ("tap", cima)
                botaoTiro:removeEventListener ("tap", teiaAtirar)

                local gameOver = display.newImageRect (grupoUI, "imagens/gameover.jpg", 1680, 1050)
                gameOver.x = display.contentCenterX
                gameOver.y = display.contentCenterY
            end -- fecha o if vidas
        end -- fecha o if myName
    end -- fecha o if event.phase
end-- fecha o function

Runtime:addEventListener ("collision", onCollision)
