local physics = require ("physics")
--Iniciar o  motor de física ----------------------------------------------------------------------------------------------------
physics.start ()
--Definir a gravidade -----------------------------------------------------------------------------------------------------------
physics.setGravity (0,0)
--definir o modo de renderização ------------------------------------------------------------------------------------------------
physics.setDrawMode ("normal")

--Remover a barra de notificações -----------------------------------------------------------------------------------------------
display.setStatusBar (display.HiddenStatusBar)

-- Variáveis para ajeitar altura e largura de acordo com celular ----------------------------------------------------------------
-- Define o objeto para a borda da direita
letterboxWidth = (display.actualContentWidth-display.contentWidth)/2
-- Define o objeto para a borda de baixo
letterboxHeight = (display.actualContentHeight-display.contentHeight)/2

--Criar os grupos de exibição ---------------------------------------------------------------------------------------------------
local grupoBg = display.newGroup()
local grupoMain = display.newGroup()
local grupoPortaDaGeladeira = display.newGroup()
local grupoUI = display.newGroup()


-- Variáveis --------------------------------------------------------------------------------------------------------------------
local tabuaComIngrediente = false
local fornoComIngrediente = false
local fornoEstaPronto = false
local tipoDoIngrediente = "nada"
local pratoNoMonte = 4
local jaTemPrato1 = false
local jaTemPrato2 = false
local jaTemPrato3 = false
local jaTemPrato4 = false
local statusPrato1 = 0 -- Depois de colocarmos o prato, voltar para 0
local statusPrato2 = 0
local statusPrato3 = 0
local statusPrato4 = 0

-- Fundo ------------------------------------------------------------------------------------------------------------------------
local bg = display.newImageRect (grupoBg, "imagens/cozinhafundo.png", 720, 480)
bg.x, bg.y = display.contentCenterX, display.contentCenterY

-- Bancada ----------------------------------------------------------------------------------------------------------------------
local bancada = display.newImageRect (grupoMain, "imagens/bancada.png", 402, 50)
bancada.x, bancada.y = display.contentCenterX -25, display.contentCenterY +23
--physics.addBody (bancada, "static")

-- Cria a barra de ferramentas --------------------------------------------------------------------------------------------------
local ferramentas = display.newImageRect (grupoMain, "imagens/Cozinha barra/ferramentas.png", 64, 272)
ferramentas.x = -32 + display.contentWidth + letterboxWidth
ferramentas.y = display.contentCenterY

-- Cria a barra de pedidos ------------------------------------------------------------------------------------------------------
local barraDePedidos = display.newImageRect (grupoUI, "imagens/barra_pedidos.png", 271, 64)
barraDePedidos.x = display.screenOriginX +135
barraDePedidos.y = display.screenOriginY +32

-- Porta da geladeira -----------------------------------------------------------------------------------------------------------
local PortaDaGeladeira = display.newImageRect (grupoPortaDaGeladeira, "imagens/geladeira.png", 144, 98)
PortaDaGeladeira.x, PortaDaGeladeira.y = -153 + display.contentCenterX, display.contentCenterY +97
physics.addBody (PortaDaGeladeira, "static")

-- Função de remover a porta da geladeira ---------------------------------------------------------------------------------------
local function removerPortaDaGeladeira ()
    display.remove (PortaDaGeladeira)
end

PortaDaGeladeira:addEventListener ("tap", removerPortaDaGeladeira)

-- Cria a sprite do forno -------------------------------------------------------------------------------------------------------
local spriteForno = graphics.newImageSheet ("imagens/forno.png", {width=96, height=46, numFrames=3})

-- Cria as opções de animações do forno -----------------------------------------------------------------------------------------
local spriteFornoAnimacao = {
        {name="desligado", start=1, count=1, time=1000, loopCount=0},
        {name="ligado", start=2, count=1, time=1000, loopCount=0},
        {name="pronto", start=3, count=1, time=1000, loopCount=0},
}

-- Insere o forno ---------------------------------------------------------------------------------------------------------------
local forno = display.newSprite (grupoMain ,spriteForno, spriteFornoAnimacao)
forno.x = display.contentCenterX -34
forno.y = display.contentCenterY +121
physics.addBody (forno, "static")
forno.myName = "forno"
forno:setSequence ("desligado")
forno:play ()

-- Função do forno "ficar pronto", com coloração cinza --------------------------------------------------------------------------
local function fornoPronto ()
    fornoEstaPronto = true
    forno:setSequence ("pronto")
    forno:play ()
end

-- Cria a sprite do fogão da esquerda -------------------------------------------------------------------------------------------
local spriteFogaoE = graphics.newImageSheet ("imagens/bocafoagaoE.png", {width=48, height=50, numFrames=8})

-- Cria as opções de animações do fogão da esquerda -----------------------------------------------------------------------------
local spriteFogaoEAnimacao = {
        {name="desligado", start=1, count=1, time=1000, loopCount=0},
        {name="comingrediente", start=2, count=1, time=1000, loopCount=0},
        {name="pronto", start=3, count=4, time=1000, loopCount=0},
        {name="queimando", start=7, count=2, time=1000, loopCount=0}
}

-- Insere o fogão da esquerda ---------------------------------------------------------------------------------------------------
local fogaoE = display.newSprite (grupoMain, spriteFogaoE, spriteFogaoEAnimacao)
fogaoE.x = display.contentCenterX -59
fogaoE.y = display.contentCenterY +73
physics.addBody (fogaoE, "static")
fogaoE.myName = "fogaoE"
fogaoE:setSequence ("desligado")
fogaoE:play ()

-- Cria a sprite do fogão da direita --------------------------------------------------------------------------------------------
local spriteFogaoD = graphics.newImageSheet ("imagens/bocafoagaoD.png", {width=48, height=50, numFrames=8})

-- Cria as opções de animações do fogão da direita ------------------------------------------------------------------------------
local spriteFogaoDAnimacao = {
        {name="desligado", start=1, count=1, time=1000, loopCount=0},
        {name="comingrediente", start=2, count=1, time=1000, loopCount=0},
        {name="pronto", start=3, count=4, time=1000, loopCount=0},
        {name="queimando", start=7, count=2, time=1000, loopCount=0}
}

-- Insere o fogão da direita ----------------------------------------------------------------------------------------------------
local fogaoD = display.newSprite (grupoMain, spriteFogaoD, spriteFogaoDAnimacao)
fogaoD.x = display.contentCenterX -9
fogaoD.y = display.contentCenterY +73
physics.addBody (fogaoD, "static")
fogaoD.myName = "fogaoD"
fogaoD:setSequence ("desligado")
fogaoD:play ()

-- Cria a sprite da tábua -------------------------------------------------------------------------------------------------------
local spriteTabua = graphics.newImageSheet ("imagens/tabua.png", {width=96, height=48, numFrames=9})

-- Cria as opções de animações da tábua -----------------------------------------------------------------------------------------
local spriteTabuaAnimacao = {
    {name="nada", start=1, count=1, time=1000, loopCount=0},
    {name="alface", start=2, count=1, time=1000, loopCount=0},
    {name="alfacecortado", start=3, count=1, time=1000, loopCount=0},
    {name="batata", start=4, count=1, time=1000, loopCount=0},
    {name="batatacortada", start=5, count=1, time=1000, loopCount=0},
    {name="tomate", start=6, count=1, time=1000, loopCount=0},
    {name="tomatecortado", start=7, count=1, time=1000, loopCount=0},
    {name="pao", start=8, count=1, time=1000, loopCount=0},
    {name="paocortado", start=9, count=1, time=1000, loopCount=0},
}

-- Insere a tábua ---------------------------------------------------------------------------------------------------------------
local tabua = display.newSprite (grupoMain ,spriteTabua, spriteTabuaAnimacao)
tabua.x = display.contentCenterX + 62
tabua.y = display.contentCenterY + 120
physics.addBody (tabua, "static")
tabua.myName = "tabua"
tabua:setSequence ("nada")
tabua:play ()

-- Cria s sprite da pia ---------------------------------------------------------------------------------------------------------
local spritePia = graphics.newImageSheet ("imagens/pia.png", {width=96, height=48, numFrames=11})

-- Cria as opções de animações da pia -------------------------------------------------------------------------------------------
local spritePiaAnimacao = {
        {name="nada", start=1, count=1, time=1000, loopCount=0},
        {name="1prato", start=2, count=1, time=1000, loopCount=0},
        {name="2prato", start=3, count=1, time=1000, loopCount=0},
        {name="3prato", start=4, count=1, time=1000, loopCount=0},
        {name="4prato", start=5, count=1, time=1000, loopCount=0},
        {name="5prato", start=6, count=1, time=1000, loopCount=0},
        {name="6prato", start=7, count=1, time=1000, loopCount=0},
        {name="7prato", start=8, count=1, time=1000, loopCount=0},
        {name="8prato", start=9, count=1, time=1000, loopCount=0},
        {name="9prato", start=10, count=1, time=1000, loopCount=0},
        {name="10prato", start=11, count=1, time=1000, loopCount=0}
}

-- Insere a pia -----------------------------------------------------------------------------------------------------------------
local pia = display.newSprite (grupoMain, spritePia, spritePiaAnimacao)
pia.x = display.contentCenterX +62
pia.y = display.contentCenterY +73
physics.addBody (pia, "static")
pia.myName = "pia"
pia:setSequence ("nada")
pia:play ()

-- Cria a sprite dos pratos -----------------------------------------------------------------------------------------------------
local spritePratos = graphics.newImageSheet ("imagens/pratos.png", {width=48, height=88, numFrames=5})

-- Cria as opções de animações dos pratos ---------------------------------------------------------------------------------------
local spritePratosAnimacao = {
        {name="nada", start=1, count=1, time=1000, loopCount=0},
        {name="1prato", start=2, count=1, time=1000, loopCount=0},
        {name="2pratos", start=3, count=1, time=1000, loopCount=0},
        {name="3pratos", start=4, count=1, time=1000, loopCount=0},
        {name="4pratos", start=5, count=1, time=1000, loopCount=0}
}

-- Insere os pratos -------------------------------------------------------------------------------------------------------------
local pratos = display.newSprite (grupoMain, spritePratos, spritePratosAnimacao)
pratos.x = display.contentCenterX +142
pratos.y = display.contentCenterY +116
physics.addBody (pratos, "static")
pratos.myName = "pratos"
pratos:setSequence ("4pratos")
pratos:play ()

-- Insere a sprite de prato1 ----------------------------------------------------------------------------------------------------
local spritePrato1 = graphics.newImageSheet ("imagens/prato.png", {width=48, height=48, numFrames=16})

-- Cria as opções de animações dos pratos ---------------------------------------------------------------------------------------
local spritePrato1Animacao = {
        {name="nada", start=1, count=1, time=1000, loopCount=0},
        {name="pratoVazio", start=2, count=1, time=1000, loopCount=0},
        {name="pratoComPao", start=3, count=1, time=1000, loopCount=0},
        {name="pratoComAlface", start=4, count=1, time=1000, loopCount=0},
        {name="pratoComBatata", start=5, count=1, time=1000, loopCount=0},
        {name="pratoComBatataFrita", start=6, count=1, time=1000, loopCount=0},
        {name="pratoComTomate", start=7, count=1, time=1000, loopCount=0},
        {name="pratoComTomateEBatata", start=8, count=1, time=1000, loopCount=0},
        {name="pratoComAlfaceETomate", start=9, count=1, time=1000, loopCount=0},
        {name="pratoComAlfaceBatataETomate", start=10, count=1, time=1000, loopCount=0},
        {name="pratoComAlfaceEBatata", start=11, count=1, time=1000, loopCount=0},
        {name="pratoComSanduicheDeAlfaceETomate", start=12, count=1, time=1000, loopCount=0},
        {name="pratoComSanduicheDeTomate", start=13, count=1, time=1000, loopCount=0},
        {name="pratoComSanduicheDeAlface", start=14, count=1, time=1000, loopCount=0},
        {name="pratoComMacarrao", start=15, count=1, time=1000, loopCount=0},
        {name="pratoComMacarraoEMolho", start=16, count=1, time=1000, loopCount=0}
}

-- Insere os prato1 -------------------------------------------------------------------------------------------------------------
local prato1 = display.newSprite (grupoMain, spritePrato1, spritePrato1Animacao)
prato1.x = display.contentCenterX -170
prato1.y = display.contentCenterY +19
physics.addBody (prato1, "static")
prato1.myName = "prato1"
prato1:setSequence ("nada")
prato1:play ()

-- Insere os prato2 -------------------------------------------------------------------------------------------------------------
local prato2 = display.newSprite (grupoMain, spritePrato1, spritePrato1Animacao)
prato2.x = display.contentCenterX -75
prato2.y = display.contentCenterY +19
physics.addBody (prato2, "static")
prato2.myName = "prato2"
prato2:setSequence ("nada")
prato2:play ()

-- Insere os prato3 -------------------------------------------------------------------------------------------------------------
local prato3 = display.newSprite (grupoMain, spritePrato1, spritePrato1Animacao)
prato3.x = display.contentCenterX +25
prato3.y = display.contentCenterY +19
physics.addBody (prato3, "static")
prato3.myName = "prato3"
prato3:setSequence ("nada")
prato3:play ()

-- Insere os prato4 -------------------------------------------------------------------------------------------------------------
local prato4 = display.newSprite (grupoMain, spritePrato1, spritePrato1Animacao)
prato4.x = display.contentCenterX +120
prato4.y = display.contentCenterY +19
physics.addBody (prato4, "static")
prato4.myName = "prato4"
prato4:setSequence ("nada")
prato4:play ()

-- Insere o pratoMovel ----------------------------------------------------------------------------------------------------------
local pratoMovel = display.newSprite (grupoMain, spritePrato1, spritePrato1Animacao)
pratoMovel.x = -800
pratoMovel.y = -800
physics.addBody (pratoMovel, "dynamic", {isSensor=true})
pratoMovel.myName = "pratoMovel"
pratoMovel:setSequence ("pratoVazio")
pratoMovel:play ()

-- Função que cria um corpo para o pratoMovel -----------------------------------------------------------------------------------
local function pratoMovelCorpo ()
    pratoMovel.bodyType = "dynamic"
end

-- Função que permite mover o pratoMovel ----------------------------------------------------------------------------------------
local function moverPratoMovel (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false
            pratoMovel.bodyType = "static"
            pratoMovel.x, pratoMovel.y = -800,-800
            timer.performWithDelay( 200, pratoMovelCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover pratoMovel ----------------------------------------------------------------------------
pratoMovel:addEventListener ("touch", moverPratoMovel)

-- Função que faz o pratoMovel surgir no monte de pratos ------------------------------------------------------------------------
local function pratoAoMonte ()
    print ("pegaum")
    if not (pratoNoMonte == 0) then
    pratoMovel.x, pratoMovel.y = pratos.x, pratos.y -20
    end
end

-- Cria um ouvinte para a função pratoAoMonte -----------------------------------------------------------------------------------
pratos:addEventListener ("tap", pratoAoMonte)

-- Insere o alface na -----------------------------------------------------------------------------------------------------------
local alface = display.newImageRect (grupoMain, "imagens/ingredientes/alface.png", 40, 36)
alface.x, alface.y = -120 + display.contentCenterX, display.contentCenterY + 78
physics.addBody (alface, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
alface.myName = "alface"

-- Função que cria um corpo para o alface ---------------------------------------------------------------------------------------
local function alfaceCorpo ()
    alface.bodyType = "dynamic"
end

-- Função que permite mover o alface --------------------------------------------------------------------------------------------
local function moverAlface (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false
            alface.bodyType = "static"
            alface.x, alface.y = -120 + display.contentCenterX, display.contentCenterY + 78
            local PortaDaGeladeira = display.newImageRect (grupoPortaDaGeladeira, "imagens/geladeira.png", 144, 98)
            PortaDaGeladeira.x, PortaDaGeladeira.y = -153 + display.contentCenterX, display.contentCenterY +97
            local function removerPortaDaGeladeira ()
                display.remove (PortaDaGeladeira)
            end
            PortaDaGeladeira:addEventListener ("tap", removerPortaDaGeladeira)
            timer.performWithDelay( 200, alfaceCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover alface --------------------------------------------------------------------------------
alface:addEventListener ("touch", moverAlface)

-- Função que restaura o alface para onde ele foi inserido originalmente --------------------------------------------------------
local function restauraAlface ()

    alface.isBodyActive = false

    transition.to (alface, {alpha=1, time=200, onComplete = function ()
        alface.isBodyActive = true
        morto = false
    end})
end

-- Insere o alface cortado ------------------------------------------------------------------------------------------------------
local alfaceCortado = display.newImageRect (grupoMain, "imagens/ingredientes/sliceAlface.png", 48, 26)
alfaceCortado.x = -300
alfaceCortado.y = -300
physics.addBody (alfaceCortado, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
alfaceCortado.myName = "alfaceCortado"

-- Dá corpo ao alfaceCortado ----------------------------------------------------------------------------------------------------
local function alfaceCortadoCorpo ()
    alfaceCortado.bodyType = "dynamic"
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local alfaceCortadoNaTabua = false

-- Função que permite mover o alfaceCortado -------------------------------------------------------------------------------------
local function moverAlfaceCortado (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            alfaceCortado.bodyType = "static"
            if alfaceCortadoNaTabua == true then
                alfaceCortado.x, alfaceCortado.y = tabua.x, tabua.y
            else
                alfaceCortado.x, alfaceCortado.y = -300, -300
            end
            timer.performWithDelay( 200, alfaceCortadoCorpo)
        end
    end
    return true
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local jaComAlface1 = false
local jaComAlface2 = false
local jaComAlface3 = false
local jaComAlface4 = false

-- Cria um ouvinte para a função de mover alfaceCortado -------------------------------------------------------------------------
alfaceCortado:addEventListener ("touch", moverAlfaceCortado)

-- Função que faz o alface surgir na tábua --------------------------------------------------------------------------------------
local function alfaceCortadoATabua ()
    alfaceCortado.x, alfaceCortado.y = tabua.x, tabua.y
end

-- Insere a batata --------------------------------------------------------------------------------------------------------------
local batata = display.newImageRect (grupoMain, "imagens/ingredientes/batata.png", 48, 44)
batata.x, batata.y = -180 + display.contentCenterX, display.contentCenterY + 78
physics.addBody (batata, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
batata.myName = "batata"

-- Função que cria um corpo para a batata ---------------------------------------------------------------------------------------
local function batataCorpo ()
    batata.bodyType = "dynamic"
end

-- Função que permite mover a batata --------------------------------------------------------------------------------------------
local function moverBatata (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            batata.bodyType = "static"
            batata.x, batata.y = -180 + display.contentCenterX, display.contentCenterY + 78
            local PortaDaGeladeira = display.newImageRect (grupoPortaDaGeladeira, "imagens/geladeira.png", 144, 98)
            PortaDaGeladeira.x, PortaDaGeladeira.y = -153 + display.contentCenterX, display.contentCenterY +97
            local function removerPortaDaGeladeira ()
                display.remove (PortaDaGeladeira)
            end
            PortaDaGeladeira:addEventListener ("tap", removerPortaDaGeladeira)
            timer.performWithDelay( 200, batataCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover batata --------------------------------------------------------------------------------
batata:addEventListener ("touch", moverBatata)

-- Função que restaura a batata para onde ela foi inserida originalmente --------------------------------------------------------
local function restauraBatata ()

    batata.isBodyActive = false

    transition.to (batata, {alpha=1, time=200, onComplete = function ()
        batata.isBodyActive = true
        morto = false
    end})
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local jaComBatata1 = false
local jaComBatata2 = false
local jaComBatata3 = false
local jaComBatata4 = false


-- Insere a batata cortada ------------------------------------------------------------------------------------------------------
local batataCortada = display.newImageRect (grupoMain, "imagens/ingredientes/slicePotato.png", 48, 26)
batataCortada.x = -400
batataCortada.y = -400
physics.addBody (batataCortada, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
batataCortada.myName = "batataCortada"

-- Dá corpo à batataCortada -----------------------------------------------------------------------------------------------------
local function batataCortadaCorpo ()
    batataCortada.bodyType = "dynamic"
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local batataCortadaNaTabua = false

-- Função que permite mover o batataCortada -------------------------------------------------------------------------------------
local function moverBatataCortada (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            batataCortada.bodyType = "static"
            if batataCortadaNaTabua == true then
                batataCortada.x, batataCortada.y = tabua.x, tabua.y
            else
                batataCortada.x, batataCortada.y = -400, -400
            end
            timer.performWithDelay( 200, batataCortadaCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover batataCortada -------------------------------------------------------------------------
batataCortada:addEventListener ("touch", moverBatataCortada)

-- Função que faz a batata surgir na tábua --------------------------------------------------------------------------------------
local function batataCortadaATabua ()
    batataCortada.x, batataCortada.y = tabua.x, tabua.y
end

-- -- Insere a batata frita --------------------------------------------------------------------------------------------------------
-- local batataFrita = display.newImageRect (grupoMain, "imagens/ingredientes/batataFrita.png", 48, 48)
-- batataFrita.x = -700
-- batataFrita.y = -700
-- physics.addBody (batataFrita, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
-- batataFrita.myName = "batataFrita"

-- -- Dá corpo à batataFrita -----------------------------------------------------------------------------------------------------
-- local function batataFritaCorpo ()
--     batataFrita.bodyType = "dynamic"
-- end

-- Insere o tomate --------------------------------------------------------------------------------------------------------------
local tomate = display.newImageRect (grupoMain, "imagens/ingredientes/tomate.png", 48, 44)
tomate.x, tomate.y = -120 + display.contentCenterX, display.contentCenterY + 118
physics.addBody (tomate, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
tomate.myName = "tomate"

-- Função que cria um corpo para o tomate ---------------------------------------------------------------------------------------
local function tomateCorpo ()
    tomate.bodyType = "dynamic"
end

-- Função que permite mover o tomate --------------------------------------------------------------------------------------------
local function moverTomate (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            tomate.bodyType = "static"
            tomate.x, tomate.y = -120 + display.contentCenterX, display.contentCenterY + 118
            local PortaDaGeladeira = display.newImageRect (grupoPortaDaGeladeira, "imagens/geladeira.png", 144, 98)
            PortaDaGeladeira.x, PortaDaGeladeira.y = -153 + display.contentCenterX, display.contentCenterY +97
            local function removerPortaDaGeladeira ()
                display.remove (PortaDaGeladeira)
            end
            PortaDaGeladeira:addEventListener ("tap", removerPortaDaGeladeira)
            timer.performWithDelay( 200, tomateCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover tomate --------------------------------------------------------------------------------
tomate:addEventListener ("touch", moverTomate)

-- Função que restaura o tomate para onde ele foi inserido originalmente --------------------------------------------------------
local function restauraTomate ()

    tomate.isBodyActive = false

    transition.to (tomate, {alpha=1, time=200, onComplete = function ()
        tomate.isBodyActive = true
        morto = false
    end})
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local jaComTomate1 = false
local jaComTomate2 = false
local jaComTomate3 = false
local jaComTomate4 = false

-- Insere o tomateCortado -------------------------------------------------------------------------------------------------------
local tomateCortado = display.newImageRect (grupoMain, "imagens/ingredientes/sliceTomato.png", 38, 32)
tomateCortado.x = -500
tomateCortado.y = -500
physics.addBody (tomateCortado, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
tomateCortado.myName = "tomateCortado"

-- Dá corpo ao tomate -----------------------------------------------------------------------------------------------------------
local function tomateCortadoCorpo ()
    tomateCortado.bodyType = "dynamic"
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local tomateCortadoNaTabua = false

-- Função que permite mover o tomateCortado -------------------------------------------------------------------------------------
local function moverTomateCortado (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            tomateCortado.bodyType = "static"
            if tomateCortadoATabua == true then
                tomateCortado.x, tomateCortado.y = tabua.x, tabua.y
            else
                tomateCortado.x, tomateCortado.y = -500, -500
            end
            timer.performWithDelay( 200, tomateCortadoCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover tomateCortado -------------------------------------------------------------------------
tomateCortado:addEventListener ("touch", moverTomateCortado)

-- Função que faz o tomate surgir na tábua --------------------------------------------------------------------------------------
local function tomateCortadoATabua ()
    tomateCortado.x, tomateCortado.y = tabua.x, tabua.y
end

--Insere o trigo ----------------------------------------------------------------------------------------------------------------
local trigo = display.newImageRect (grupoMain, "imagens/ingredientes/trigo.png", 48, 44)
trigo.x, trigo.y = -180 + display.contentCenterX, display.contentCenterY + 116
physics.addBody (trigo, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
trigo.myName = "trigo"

-- Função que cria um corpo para o trigo ----------------------------------------------------------------------------------------
local function trigoCorpo ()
    trigo.bodyType = "dynamic"
end

-- Função que permite mover o trigo ---------------------------------------------------------------------------------------------
local function moverTrigo (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            trigo.bodyType = "static"
            trigo.x, trigo.y = -180 + display.contentCenterX, display.contentCenterY + 118
            local PortaDaGeladeira = display.newImageRect (grupoPortaDaGeladeira, "imagens/geladeira.png", 144, 98)
            PortaDaGeladeira.x, PortaDaGeladeira.y = -153 + display.contentCenterX, display.contentCenterY +97
            local function removerPortaDaGeladeira ()
                display.remove (PortaDaGeladeira)
            end
            PortaDaGeladeira:addEventListener ("tap", removerPortaDaGeladeira)
            timer.performWithDelay( 200, trigoCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover trigo ---------------------------------------------------------------------------------
trigo:addEventListener ("touch", moverTrigo)

-- Função que restaura o trigo para onde foi inserido originalmente -------------------------------------------------------------
local function restauraTrigo ()

    trigo.isBodyActive = false

    transition.to (trigo, {alpha=1, time=200, onComplete = function ()
        trigo.isBodyActive = true
        morto = false
    end})
end

-- Cria o pao -------------------------------------------------------------------------------------------------------------------
local pao = display.newImageRect (grupoMain, "imagens/ingredientes/bread.png", 42, 22)
pao.x = -200
pao.y = -200
physics.addBody (pao, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
pao.myName = "pao"

-- Dá corpo ao pão --------------------------------------------------------------------------------------------------------------
local function paoCorpo ()
    pao.bodyType = "dynamic"
end

-- Função que permite mover o pao ----------------------------------------------------------------------------------------------
local function moverPao (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false
            pao.bodyType = "static"
            pao.x, pao.y = -200, -200
            timer.performWithDelay( 200, paoCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover pao ----------------------------------------------------------------------------------
pao:addEventListener ("touch", moverPao)

-- Função que faz o pão surgir no forno -----------------------------------------------------------------------------------------
local function paoAoForno ()
    print ("saipao")
    if fornoEstaPronto == true then
    pao.x, pao.y = forno.x, forno.y
    end
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local jaComPao1 = false
local jaComPao2 = false
local jaComPao3 = false
local jaComPao4 = false

-- Insere o paoCortado ----------------------------------------------------------------------------------------------------------
local paoCortado = display.newImageRect (grupoMain, "imagens/ingredientes/sliceBread.png", 56, 22)
paoCortado.x = -600
paoCortado.y = -600
physics.addBody (paoCortado, "dynamic", {isSensor=true, density= 1, friction= 0, bounce= 0})
paoCortado.myName = "paoCortado"

-- Dá corpo ao tomate -----------------------------------------------------------------------------------------------------------
local function paoCortadoCorpo ()
    paoCortado.bodyType = "dynamic"
end

-- Variável ---------------------------------------------------------------------------------------------------------------------
local paoCortadoNaTabua = false

-- Função que permite mover o paoCortado ----------------------------------------------------------------------------------------
local function moverPaoCortado (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            paoCortado.bodyType = "static"
            if paoCortadoNaTabua == true then
                paoCortado.x, paoCortado.y = tabua.x, tabua.y
                print ("taali")
            else
                paoCortado.x, paoCortado.y = -600, -600
            end
            timer.performWithDelay( 200, paoCortadoCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover paoCortado ----------------------------------------------------------------------------
paoCortado:addEventListener ("touch", moverPaoCortado)

-- Função que faz o pão surgir no forno -----------------------------------------------------------------------------------------
local function paoCortadoATabua ()
    paoCortado.x, paoCortado.y = tabua.x, tabua.y
end

-- Cria a sprite da luva --------------------------------------------------------------------------------------------------------
local luva = display.newImageRect (grupoMain, "imagens/Cozinha barra/luva.png", 48, 44)
luva.x = display.contentWidth + letterboxWidth -32
luva.y = display.contentCenterY -85
physics.addBody (luva, "dynamic", {isSensor=true})
luva.myName = "luva"

-- Função que dá corpo à luva ---------------------------------------------------------------------------------------------------
local function luvaCorpo ()
    luva.bodyType = "dynamic"
end

-- Função que faz a luva se mover -----------------------------------------------------------------------------------------------
local function moverLuva (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            luva.bodyType = "static"
            luva.x, luva.y = display.contentWidth + letterboxWidth -32, display.contentCenterY -85
            timer.performWithDelay( 200, luvaCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover luva ---------------------------------------------------------------------------------
luva:addEventListener ("touch", moverLuva)

-- Função que rastaura a luva para a posição de origem --------------------------------------------------------------------------
local function restauraLuva ()

    luva.isBodyActive = false

    transition.to (luva, {alpha=1, time=200, onComplete = function ()
        luva.isBodyActive = true
        morto = false
    end})
end

-- Cria a sprite da colher ------------------------------------------------------------------------------------------------------
local colher = display.newImageRect (grupoMain, "imagens/Cozinha barra/colher.png", 48, 44)
colher.x = display.contentWidth + letterboxWidth -32
colher.y = display.contentCenterY -30
physics.addBody (colher, "dynamic", {isSensor=true})
colher.myName = "colher"

-- Função que dá corpo à colher -------------------------------------------------------------------------------------------------
local function colherCorpo ()
    colher.bodyType = "dynamic"
end

-- Função que faz a colher se mover ---------------------------------------------------------------------------------------------
local function moverColher (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            colher.bodyType = "static"
            colher.x, colher.y = display.contentWidth + letterboxWidth -32, display.contentCenterY -30
            timer.performWithDelay( 200, colherCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover colher --------------------------------------------------------------------------------
colher:addEventListener ("touch", moverColher)

-- Função que rastaura a colher para a posição de origem ------------------------------------------------------------------------
local function restauraColher ()

    colher.isBodyActive = false

    transition.to (colher, {alpha=1, time=200, onComplete = function ()
        colher.isBodyActive = true
        morto = false
    end})
end

-- Cria a sprite da faca --------------------------------------------------------------------------------------------------------
local faca = display.newImageRect (grupoMain, "imagens/Cozinha barra/faca.png", 48, 44)
faca.x = display.contentWidth + letterboxWidth -32
faca.y = display.contentCenterY +27
physics.addBody (faca, "dynamic", {isSensor=true})
faca.myName = "faca"

-- Função que dá corpo à faca ---------------------------------------------------------------------------------------------------
local function facaCorpo ()
    faca.bodyType = "dynamic"
end

-- Função que faz a faca se mover -----------------------------------------------------------------------------------------------
local function moverFaca (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            faca.bodyType = "static"
            faca.x, faca.y = display.contentWidth + letterboxWidth -32, display.contentCenterY +27
            timer.performWithDelay( 200, facaCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover faca ----------------------------------------------------------------------------------
faca:addEventListener ("touch", moverFaca)

-- Função que rastaura a faca para a posição de origem --------------------------------------------------------------------------
local function restauraFaca ()

    faca.isBodyActive = false

    transition.to (faca, {alpha=1, time=200, onComplete = function ()
        faca.isBodyActive = true
        morto = false
    end})
end


-- Cria a sprite da mão ---------------------------------------------------------------------------------------------------------
local mao = display.newImageRect (grupoMain, "imagens/Cozinha barra/slecionar.png", 48, 44)
mao.x = display.contentWidth + letterboxWidth -32
mao.y = display.contentCenterY +82
physics.addBody (mao, "dynamic", {isSensor=true})
mao.myName = "mao"

-- Função que dá corpo à mao ----------------------------------------------------------------------------------------------------
local function maoCorpo ()
    mao.bodyType = "dynamic"
end

-- Função que faz a mao se mover ------------------------------------------------------------------------------------------------
local function moverMao (event)
    local body = event.target
    local phase = event.phase

    if ("began" == phase) then
        display.getCurrentStage (): setFocus (body,event.id)
        body.isFocus = true
        -- cria a junta para mover
        body.tempJoint = physics.newJoint ("touch", body, event.x, event.y)
        body.isFixedRotation = true
    elseif (body.isFocus) then
        if ("moved" == phase) then
            body.tempJoint:setTarget (event.x, event.y)
        elseif ("ended" == phase or "canceled" == phase) then
            display.getCurrentStage ():setFocus (body, nil)
            body.isFocus = false
            event.target:setLinearVelocity (0,0)
            event.target.angularVelocity = 0
            body.tempJoint:removeSelf ()
            body.isFixedRotation = false -- deve ser comentado caso não queira que o heroi gire na agua
            mao.bodyType = "static"
            mao.x, mao.y = display.contentWidth + letterboxWidth -32, display.contentCenterY +82
            timer.performWithDelay( 200, maoCorpo)
        end
    end
    return true
end

-- Cria um ouvinte para a função de mover mao -----------------------------------------------------------------------------------
mao:addEventListener ("touch", moverMao)

-- Função que rastaura a mao para a posição de origem ---------------------------------------------------------------------------
local function restauraMao ()

    mao.isBodyActive = false

    transition.to (mao, {alpha=1, time=200, onComplete = function ()
        mao.isBodyActive = true
        morto = false
    end})
end

-- Cria a sprite dos pedidos ----------------------------------------------------------------------------------------------------
local spritePedidos = graphics.newImageSheet ("imagens/pedidos.png", {width=56, height=60, numFrames=15})

-- Cria as opções de animações dos pedidos --------------------------------------------------------------------------------------
local spritePedidosAnimacao = {
        {name="nada", start=1, count=1, time=1000, loopCount=0},
        {name="pao", start=2, count=1, time=1000, loopCount=0},
        {name="alface", start=3, count=1, time=1000, loopCount=0},
        {name="batata", start=4, count=1, time=1000, loopCount=0},
        {name="batataFrita", start=5, count=1, time=1000, loopCount=0},
        {name="tomate", start=6, count=1, time=1000, loopCount=0},
        {name="tomateEBatata", start=7, count=1, time=1000, loopCount=0},
        {name="alfaceETomate", start=8, count=1, time=1000, loopCount=0},
        {name="alfaceTomateEBatata", start=9, count=1, time=1000, loopCount=0},
        {name="alfaceEBatata", start=10, count=1, time=1000, loopCount=0},
        {name="paoDeAlfaceETomate", start=11, count=1, time=1000, loopCount=0},
        {name="paoETomate", start=12, count=1, time=1000, loopCount=0},
        {name="paoEAlface", start=13, count=1, time=1000, loopCount=0},
        {name="macarraao", start=14, count=1, time=1000, loopCount=0},
        {name="macarraoComMolho", start=15, count=1, time=1000, loopCount=0}
}

-- Insere os pedidos ------------------------------------------------------------------------------------------------------------
local pedidos = display.newSprite (grupoUI, spritePedidos, spritePedidosAnimacao)
pedidos.x = display.screenOriginX +38
pedidos.y = display.screenOriginY +30
pedidos.myName = "pedidos"
pedidos:setSequence ("nada")
pedidos:play ()

-- Insere os pedidos2 -----------------------------------------------------------------------------------------------------------
local pedidos2 = display.newSprite (grupoUI, spritePedidos, spritePedidosAnimacao)
pedidos2.x = display.screenOriginX +98
pedidos2.y = display.screenOriginY +30
pedidos2.myName = "pedidos2"
pedidos2:setSequence ("nada")
pedidos2:play ()

-- Insere os pedidos3 -----------------------------------------------------------------------------------------------------------
local pedidos3 = display.newSprite (grupoUI, spritePedidos, spritePedidosAnimacao)
pedidos3.x = display.screenOriginX +158
pedidos3.y = display.screenOriginY +30
pedidos3.myName = "pedidos3"
pedidos3:setSequence ("nada")
pedidos3:play ()

-- Insere os pedidos4 -----------------------------------------------------------------------------------------------------------
local pedidos4 = display.newSprite (grupoUI, spritePedidos, spritePedidosAnimacao)
pedidos4.x = display.screenOriginX +218
pedidos4.y = display.screenOriginY +30
pedidos4.myName = "pedidos4"
pedidos4:setSequence ("nada")
pedidos4:play ()

-- Função que faz os objetos colidirem ------------------------------------------------------------------------------------------
local function onColision (event)
    if (event.phase == "began") then
        local obj1 = event.object1
        local obj2 = event.object2

        --Colisão que coloca o alface na tábua ----------------------------------------------------------------------------------
        if ((obj1.myName == "alface" and obj2.myName == "tabua") or (obj2.myName == "alface" and obj1.myName == "tabua")) then
            if (tabuaComIngrediente == false) then
                tabua:setSequence ("alface")
                tipoDoIngrediente = "alface"
                tabuaComIngrediente = true
                alface.alpha = 0
                timer.performWithDelay (100, restauraAlface)
            end
        end
        -- Colisão que coloca a batata na tábua ---------------------------------------------------------------------------------
        if ((obj1.myName == "batata" and obj2.myName == "tabua") or (obj2.myName == "batata" and obj1.myName == "tabua")) then
            if (tabuaComIngrediente == false) then
                tabua:setSequence ("batata")
                tipoDoIngrediente = "batata"
                tabuaComIngrediente = true
                batata.alpha = 0
                timer.performWithDelay (100, restauraBatata)
            end
        end
        -- Colisão que coloca o tomate na tábua ---------------------------------------------------------------------------------
        if ((obj1.myName == "tomate" and obj2.myName == "tabua") or (obj2.myName == "tomate" and obj1.myName == "tabua")) then
            if (tabuaComIngrediente == false) then
                tabua:setSequence ("tomate")
                tipoDoIngrediente = "tomate"
                tabuaComIngrediente = true
                tomate.alpha = 0
                timer.performWithDelay (100, restauraTomate)
            end
        end
        -- Colisão que faz o forno ligar quando coloca o trigo ------------------------------------------------------------------
        if ((obj1.myName == "forno" and obj2.myName == "trigo") or (obj2.myName == "forno" and obj1.myName == "trigo")) then
            if (fornoComIngrediente == false) then
                forno:setSequence ("ligado")
                fornoComIngrediente = true
                trigo.alpha = 0
                timer.performWithDelay (100, restauraTrigo)
                timer.performWithDelay (2000, fornoPronto)
            end
        end
        -- Colisão que faz o forno abrir com a luva -----------------------------------------------------------------------------
        if ((obj1.myName == "luva" and obj2.myName == "forno") or (obj2.myName == "luva" and obj1.myName == "forno")) then
            luva.alpha = 0
            timer.performWithDelay (100, restauraLuva)
            timer.performWithDelay (150, paoAoForno)
        end
        -- Colisão que coloca o pão na tábua ------------------------------------------------------------------------------------
        if ((obj1.myName == "pao" and obj2.myName == "tabua") or (obj2.myName == "pao" and obj1.myName == "tabua")) then
            if (tabuaComIngrediente == false) then
                tabua:setSequence ("pao")
                tipoDoIngrediente = "pao"
                tabuaComIngrediente = true
                fornoComIngrediente = false
                timer.performWithDelay (100, restauraPao)
                forno:setSequence ("desligado")
            end
        end
        -- Colisão que faz a faca cortas os ingredientes ------------------------------------------------------------------------
        if ((obj1.myName == "faca" and obj2.myName == "tabua") or (obj2.myName == "faca" and obj1.myName == "tabua")) then
            if (tabuaComIngrediente == true) then
                if tipoDoIngrediente == "alface" then
                    tabua:setSequence ("alfacecortado")
                    timer.performWithDelay (150, alfaceCortadoATabua)
                    alfaceCortadoNaTabua = true
                    faca.alpha = 0
                    timer.performWithDelay (100, restauraFaca)
                elseif (tipoDoIngrediente == "batata") then
                    tabua:setSequence ("batatacortada")
                    timer.performWithDelay (150, batataCortadaATabua)
                    batataCortadaNaTabua = true
                    faca.alpha = 0
                    timer.performWithDelay (100, restauraFaca)
                elseif (tipoDoIngrediente == "tomate") then
                    tabua:setSequence ("tomatecortado")
                    timer.performWithDelay (150, tomateCortadoATabua)
                    tomateCortadoNaTabua = true
                    faca.alpha = 0
                    timer.performWithDelay (100, restauraFaca)
                elseif (tipoDoIngrediente == "pao") then
                    tabua:setSequence ("paocortado")
                    timer.performWithDelay (150, paoCortadoATabua)
                    paoCortadoNaTabua = true
                    faca.alpha = 0
                    timer.performWithDelay (100, restauraFaca)
                end
            end
        end
        -- Colisão que coloca o prato1 ------------------------------------------------------------------------------------------
        if ((obj1.myName == "pratoMovel" and obj2.myName == "prato1") or (obj2.myName == "pratoMovel" and obj1.myName == "prato1")) then
            if (jaTemPrato1 == false) then
                prato1:setSequence ("pratoVazio")
                if pratoNoMonte == 4 then
                    pratos:setSequence ("3pratos")
                    jaTemPrato1 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato1 = 1
                elseif pratoNoMonte == 3 then
                    pratos:setSequence ("2pratos")
                    jaTemPrato1 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato1 = 1
                elseif pratoNoMonte == 2 then
                    pratos:setSequence ("1prato")
                    jaTemPrato1 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato1 = 1
                elseif pratoNoMonte == 1 then
                    pratos:setSequence ("nada")
                    jaTemPrato1 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato1 = 1
                end
            end
        end
        -- Colisão que coloca o prato2 ------------------------------------------------------------------------------------------
        if ((obj1.myName == "pratoMovel" and obj2.myName == "prato2") or (obj2.myName == "pratoMovel" and obj1.myName == "prato2")) then
            if (jaTemPrato2 == false) then
                prato2:setSequence ("pratoVazio")
                if pratoNoMonte == 4 then
                    pratos:setSequence ("3pratos")
                    jaTemPrato2 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato2 = 1
                elseif pratoNoMonte == 3 then
                    pratos:setSequence ("2pratos")
                    jaTemPrato2 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato2 = 1
                elseif pratoNoMonte == 2 then
                    pratos:setSequence ("1prato")
                    jaTemPrato2 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato2 = 1
                elseif pratoNoMonte == 1 then
                    pratos:setSequence ("nada")
                    jaTemPrato2 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato2 = 1
                end
            end
        end
        -- Colisão que coloca o prato3 ------------------------------------------------------------------------------------------
        if ((obj1.myName == "pratoMovel" and obj2.myName == "prato3") or (obj2.myName == "pratoMovel" and obj1.myName == "prato3")) then
            if (jaTemPrato3 == false) then
                prato3:setSequence ("pratoVazio")
                if pratoNoMonte == 4 then
                    pratos:setSequence ("3pratos")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 3 then
                    pratos:setSequence ("2pratos")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 2 then
                    pratos:setSequence ("1prato")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 1 then
                    pratos:setSequence ("nada")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                end
            end
        end
                -- Colisão que coloca o prato3 ------------------------------------------------------------------------------------------
        if ((obj1.myName == "pratoMovel" and obj2.myName == "prato3") or (obj2.myName == "pratoMovel" and obj1.myName == "prato3")) then
            if (jaTemPrato3 == false) then
                prato3:setSequence ("pratoVazio")
                if pratoNoMonte == 4 then
                    pratos:setSequence ("3pratos")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 3 then
                    pratos:setSequence ("2pratos")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 2 then
                    pratos:setSequence ("1prato")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                elseif pratoNoMonte == 1 then
                    pratos:setSequence ("nada")
                    jaTemPrato3 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato3 = 1
                end
            end
        end
        -- Colisão que coloca o prato4 ------------------------------------------------------------------------------------------
        if ((obj1.myName == "pratoMovel" and obj2.myName == "prato4") or (obj2.myName == "pratoMovel" and obj1.myName == "prato4")) then
            if (jaTemPrato4 == false) then
                prato4:setSequence ("pratoVazio")
                if pratoNoMonte == 4 then
                    pratos:setSequence ("3pratos")
                    jaTemPrato4 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato4 = 1
                elseif pratoNoMonte == 3 then
                    pratos:setSequence ("2pratos")
                    jaTemPrato4 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato4 = 1
                elseif pratoNoMonte == 2 then
                    pratos:setSequence ("1prato")
                    jaTemPrato4 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato4 = 1
                elseif pratoNoMonte == 1 then
                    pratos:setSequence ("nada")
                    jaTemPrato4 = true
                    pratoNoMonte = pratoNoMonte -1
                    statusPrato4 = 1
                end
            end
        end
        -- Colisão que cria e executa as opções de comidas com alface cortado no prato1 -----------------------------------------
        if ((obj1.myName == "prato1" and obj2.myName == "alfaceCortado") or (obj2.myName == "prato1" and obj1.myName == "alfaceCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato1 = statusPrato1 * 2 --numero do ingrediente --
            print ("colidiu")
            if jaComAlface1 == false then
                if statusPrato1 == 2 then -- somente o alface
                    prato1:setSequence ("pratoComAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato1 == 6 then -- alface e pão
                    prato1:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato1 == 10 then -- alface e batata
                    prato1:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato1 == 14 then --- alface e tomate
                    prato1:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato1 == 70 then -- alface, batata e tomate
                    prato1:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato1 == 42 then -- alface, tomate e pão
                    prato1:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                end
                jaComAlface1 = true
                print ("statusprato ".. statusPrato1)
            end
        end
        -- Colisão que cria e executa as opções de comidas com batata cortada no prato1 -----------------------------------------
        if ((obj1.myName == "prato1" and obj2.myName == "batataCortada") or (obj2.myName == "prato1" and obj1.myName == "batataCortada")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato1 = statusPrato1 * 5 --numero do ingrediente --
            print ("colidiu")
            if jaComBatata1 == false then
                if statusPrato1 == 5 then -- somente batata
                    prato1:setSequence ("pratoComBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato1 == 10 then -- alface e batata
                    prato1:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato1 == 35 then -- batata e tomate
                    prato1:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato1 == 70 then -- alface, batata e tomate
                    prato1:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                end
                jaComBatata1 = true
                print ("statusprato ".. statusPrato1)
            end
        end
        -- Colisão que cria e executa as opções de comidas com tomate cortado no prato1 -----------------------------------------
        if ((obj1.myName == "prato1" and obj2.myName == "tomateCortado") or (obj2.myName == "prato1" and obj1.myName == "tomateCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato1 = statusPrato1 * 7 --numero do ingrediente --
            print ("colidiu")
            if jaComTomate1 == false then
                if statusPrato1 == 7 then -- somente tomate
                    prato1:setSequence ("pratoComTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato1 == 35 then -- tomate e batata
                    prato1:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato1 == 14 then -- alface e tomate
                    prato1:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato1 == 70 then -- alface, batata e tomate
                    prato1:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato1 == 42 then -- pão, alface e tomate
                    prato1:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato1 == 21 then -- pão e tomate
                    prato1:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                end
                jaComTomate1 = true
                print ("statusprato ".. statusPrato1)
            end
        end
        -- Colisão que cria e executa as opções de comidas com pão cortado no prato1 --------------------------------------------
        if ((obj1.myName == "prato1" and obj2.myName == "paoCortado") or (obj2.myName == "prato1" and obj1.myName == "paoCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato1 = statusPrato1 * 3 --numero do ingrediente --
            print ("colidiu")
            if jaComPao1 == false then
                if statusPrato1 == 3 then -- somente o pão
                    prato1:setSequence ("pratoComPao")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato1 == 6 then -- alface e pão
                    prato1:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato1 == 21 then -- pão e tomate
                    prato1:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato1 == 42 then -- alface, tomate e pão
                    prato1:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                end
                jaComPao1 = true
                print ("statusprato ".. statusPrato1)
            end
        end
        -- Colisão que cria e executa as opções de comidas com alface cortado no prato2 -----------------------------------------
        if ((obj1.myName == "prato2" and obj2.myName == "alfaceCortado") or (obj2.myName == "prato2" and obj1.myName == "alfaceCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato2 = statusPrato2 * 2 --numero do ingrediente --
            print ("colidiu")
            if jaComAlface2 == false then
                if statusPrato2 == 2 then -- somente o alface
                    prato2:setSequence ("pratoComAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato2 == 6 then -- alface e pão
                    prato2:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato2 == 10 then -- alface e batata
                    prato2:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato2 == 14 then --- alface e tomate
                    prato2:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato2 == 70 then -- alface, batata e tomate
                    prato2:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato2 == 42 then -- alface, tomate e pão
                    prato2:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                end
                jaComAlface2 = true
                print ("statusprato ".. statusPrato2)
            end
        end
        -- Colisão que cria e executa as opções de comidas com batata cortada no prato2 -----------------------------------------
        if ((obj1.myName == "prato2" and obj2.myName == "batataCortada") or (obj2.myName == "prato2" and obj1.myName == "batataCortada")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato2 = statusPrato2 * 5 --numero do ingrediente --
            print ("colidiu")
            if jaComBatata2 == false then
                if statusPrato2 == 5 then -- somente batata
                    prato2:setSequence ("pratoComBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato2 == 10 then -- alface e batata
                    prato2:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato2 == 35 then -- batata e tomate
                    prato2:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato2 == 70 then -- alface, batata e tomate
                    prato2:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                end
                jaComBatata2 = true
                print ("statusprato ".. statusPrato2)
            end
        end
        -- Colisão que cria e executa as opções de comidas com tomate cortado no prato2 -----------------------------------------
        if ((obj1.myName == "prato2" and obj2.myName == "tomateCortado") or (obj2.myName == "prato2" and obj1.myName == "tomateCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato2 = statusPrato2 * 7 --numero do ingrediente --
            print ("colidiu")
            if jaComTomate2 == false then
                if statusPrato2 == 7 then -- somente tomate
                    prato2:setSequence ("pratoComTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato2 == 14 then -- alface e tomate
                    prato2:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato2 == 35 then -- tomate e batata
                    prato2:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato2 == 70 then -- alface, batata e tomate
                    prato2:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato2 == 42 then -- pão, alface e tomate
                    prato2:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato2 == 21 then -- pão e tomate
                    prato2:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                end
                jaComTomate2 = true
                print ("statusprato ".. statusPrato2)
            end
        end
        -- Colisão que cria e executa as opções de comidas com pão cortado no prato2 --------------------------------------------
        if ((obj1.myName == "prato2" and obj2.myName == "paoCortado") or (obj2.myName == "prato2" and obj1.myName == "paoCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato2 = statusPrato2 * 3 --numero do ingrediente --
            print ("colidiu")
            if jaComPao2 == false then
                if statusPrato2 == 3 then -- somente o pão
                    prato2:setSequence ("pratoComPao")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato2 == 6 then -- alface e pão
                    prato2:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato2 == 21 then -- pão e tomate
                    prato2:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato2 == 42 then -- alface, tomate e pão
                    prato2:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                end
                jaComPao2 = true
                print ("statusprato ".. statusPrato2)
            end
        end
        -- Colisão que cria e executa as opções de comidas com alface cortado no prato3 -----------------------------------------
        if ((obj1.myName == "prato3" and obj2.myName == "alfaceCortado") or (obj2.myName == "prato3" and obj1.myName == "alfaceCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato3 = statusPrato3 * 2 --numero do ingrediente --
            print ("colidiu")
            if jaComAlface3 == false then
                if statusPrato3 == 2 then -- somente o alface
                    prato3:setSequence ("pratoComAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato3 == 6 then -- alface e pão
                    prato3:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato3 == 10 then -- alface e batata
                    prato3:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato3 == 14 then --- alface e tomate
                    prato3:setSequence ("pratoComAlfaceETomate")-- coloque o nome da squencia com alface e tomate
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato3 == 70 then -- alface, batata e tomate
                    prato3:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato3 == 42 then -- alface, tomate e pão
                    prato3:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                end
                jaComAlface3 = true
                print ("statusprato ".. statusPrato3)
            end
        end
        -- Colisão que cria e executa as opções de comidas com batata cortada no prato3 -----------------------------------------
        if ((obj1.myName == "prato3" and obj2.myName == "batataCortada") or (obj2.myName == "prato3" and obj1.myName == "batataCortada")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato3 = statusPrato3 * 5 --numero do ingrediente --
            print ("colidiu")
            if jaComBatata3 == false then
                if statusPrato3 == 5 then -- somente batata
                    prato3:setSequence ("pratoComBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato3 == 10 then -- alface e batata
                    prato3:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato3 == 35 then -- tomate e batata
                    prato3:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 70 then -- alface, batata e tomate
                    prato3:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                end
                jaComBatata3 = true
                print ("statusprato ".. statusPrato3)
            end
        end
        -- Colisão que cria e executa as opções de comidas com tomate cortado no prato3 -----------------------------------------
        if ((obj1.myName == "prato3" and obj2.myName == "tomateCortado") or (obj2.myName == "prato3" and obj1.myName == "tomateCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato3 = statusPrato3 * 7 --numero do ingrediente --
            print ("colidiu")
            if jaComTomate3 == false then
                if statusPrato3 == 7 then -- somente tomate
                    prato3:setSequence ("pratoComTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 35 then -- tomate e batata
                    prato3:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 14 then -- alface e tomate
                    prato3:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 70 then -- alface, batata e tomate
                    prato3:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 42 then -- pão, alface e tomate
                    prato3:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato3 == 21 then -- pão e tomate
                    prato3:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                end
                jaComTomate3 = true
                print ("statusprato ".. statusPrato3)
            end
        end
        -- Colisão que cria e executa as opções de comidas com pão cortado no prato3 --------------------------------------------
        if ((obj1.myName == "prato3" and obj2.myName == "paoCortado") or (obj2.myName == "prato3" and obj1.myName == "paoCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato3 = statusPrato3 * 3 --numero do ingrediente --
            print ("colidiu")
            if jaComPao3 == false then
                if statusPrato3 == 3 then -- somente o pão
                    prato3:setSequence ("pratoComPao")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato3 == 6 then -- alface e pão
                    prato3:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato3 == 21 then -- pão e tomate
                    prato3:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato3 == 42 then -- alface, tomate e pão
                    prato3:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                end
                jaComPao3 = true
                print ("statusprato ".. statusPrato3)
            end
        end
        -- Colisão que cria e executa as opções de comidas com alface cortado no prato4 -----------------------------------------
        if ((obj1.myName == "prato4" and obj2.myName == "alfaceCortado") or (obj2.myName == "prato4" and obj1.myName == "alfaceCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato4 = statusPrato4 * 2 --numero do ingrediente --
            print ("colidiu")
            if jaComAlface4 == false then
                if statusPrato4 == 2 then -- somente o alface
                    prato4:setSequence ("pratoComAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato4 == 6 then -- alface e pão
                    prato4:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato4 == 10 then -- alface e batata
                    prato4:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato4 == 14 then --- alface e tomate
                    prato4:setSequence ("pratoComAlfaceETomate")-- coloque o nome da squencia com alface e tomate
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato4 == 70 then -- alface, batata e tomate
                    prato4:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                elseif statusPrato4 == 42 then -- alface, tomate e pão
                    prato4:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    alfaceCortadoNaTabua = false
                end
                jaComAlface4 = true
                print ("statusprato ".. statusPrato4)
            end
        end
        -- Colisão que cria e executa as opções de comidas com batata cortada no prato4 -----------------------------------------
        if ((obj1.myName == "prato4" and obj2.myName == "batataCortada") or (obj2.myName == "prato4" and obj1.myName == "batataCortada")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato4 = statusPrato4 * 5 --numero do ingrediente --
            print ("colidiu")
            if jaComBatata4 == false then
                if statusPrato4 == 5 then -- somente batata
                    prato4:setSequence ("pratoComBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato4 == 10 then -- alface e batata
                    prato4:setSequence ("pratoComAlfaceEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                elseif statusPrato4 == 35 then -- tomate e batata
                    prato4:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 70 then -- alface, batata e tomate
                    prato4:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    batataCortadaNaTabua = false
                end
                jaComBatata4 = true
                print ("statusprato ".. statusPrato4)
            end
        end
        -- Colisão que cria e executa as opções de comidas com tomate cortado no prato4 -----------------------------------------
        if ((obj1.myName == "prato4" and obj2.myName == "tomateCortado") or (obj2.myName == "prato4" and obj1.myName == "tomateCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13, batata frita = 17 ----------------------------------------------------------------------------------------------------------------
            statusPrato4 = statusPrato4 * 7 --numero do ingrediente --
            print ("colidiu")
            if jaComTomate4 == false then
                if statusPrato4 == 7 then -- somente tomate
                    prato4:setSequence ("pratoComTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 35 then -- tomate e batata
                    prato4:setSequence ("pratoComTomateEBatata")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 14 then -- alface e tomate
                    prato4:setSequence ("pratoComAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 70 then -- alface, batata e tomate
                    prato4:setSequence ("pratoComAlfaceBatataETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 42 then -- pão, alface e tomate
                    prato4:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                elseif statusPrato4 == 21 then -- pão e tomate
                    prato4:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    tomateCortadoNaTabua = false
                end
                jaComTomate4 = true
                print ("statusprato ".. statusPrato4)
            end
        end
        -- Colisão que cria e executa as opções de comidas com pão cortado no prato4 --------------------------------------------
        if ((obj1.myName == "prato4" and obj2.myName == "paoCortado") or (obj2.myName == "prato4" and obj1.myName == "paoCortado")) then
            --nada = 0, prato=1, alface=2, pão = 3, batata = 5, tomate = 7, macarrão = 11, macarrão com molho = 13 ---
            statusPrato4 = statusPrato4 * 3 --numero do ingrediente --
            print ("colidiu")
            if jaComPao4 == false then
                if statusPrato4 == 3 then -- somente o pão
                    prato4:setSequence ("pratoComPao")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato4 == 6 then -- alface e pão
                    prato4:setSequence ("pratoComSanduicheDeAlface")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato4 == 21 then -- pão e tomate
                    prato4:setSequence ("pratoComSanduicheDeTomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                elseif statusPrato4 == 42 then -- alface, tomate e pão
                    prato4:setSequence ("pratoComSanduicheDeAlfaceETomate")
                    tabua:setSequence ("nada")
                    tabuaComIngrediente = false
                    paoCortadoNaTabua = false
                end
                jaComPao4 = true
                print ("statusprato ".. statusPrato4)
            end
        end
    end
end

-- Cria um ouvinte para a função de colisão -------------------------------------------------------------------------------------
Runtime:addEventListener ("collision", onColision)

-- Variável ---------------------------------------------------------------------------------------------------------------------
local pratosNaPia = 0

-- Função pra testar a entrega do prato1 ----------------------------------------------------------------------------------------
local function entrega1 ()
    if not (statusPrato1 == -1) then
        prato1:setSequence ("nada")
        jaComPao1 = false
        jaComAlface1 = false
        jaComBatata1 = false
        jaComTomate1 = false
        jaTemPrato1 = false
        statusPrato1 = -1
        if pratosNaPia == 3 then
            pia:setSequence ("4prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 2 then
            pia:setSequence ("3prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 1 then
            pia:setSequence ("2prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 0 then
            pia:setSequence ("1prato")
            pratosNaPia = pratosNaPia +1
        end
    end
end

prato1:addEventListener ("tap", entrega1)

-- Função pra testar a entrega do prato2 ----------------------------------------------------------------------------------------
local function entrega2 ()
    if not (statusPrato2 == -1) then
        prato2:setSequence ("nada")
        jaComPao1 = false
        jaComAlface2 = false
        jaComBatata2 = false
        jaComTomate2 = false
        jaTemPrato2 = false
        statusPrato2 = -1
        if pratosNaPia == 3 then
            pia:setSequence ("4prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 2 then
            pia:setSequence ("3prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 1 then
            pia:setSequence ("2prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 0 then
            pia:setSequence ("1prato")
            pratosNaPia = pratosNaPia +1
        end
    end
end

prato2:addEventListener ("tap", entrega2)

-- Função pra testar a entrega do prato3 ----------------------------------------------------------------------------------------
local function entrega3 ()
    if not (statusPrato3 == -1) then
        prato3:setSequence ("nada")
        jaComPao3 = false
        jaComAlface3 = false
        jaComBatata3 = false
        jaComTomate3 = false
        jaTemPrato3 = false
        statusPrato3 = -1
        if pratosNaPia == 3 then
            pia:setSequence ("4prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 2 then
            pia:setSequence ("3prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 1 then
            pia:setSequence ("2prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 0 then
            pia:setSequence ("1prato")
            pratosNaPia = pratosNaPia +1
        end
    end
end

prato3:addEventListener ("tap", entrega3)

-- Função pra testar a entrega do prato4 ----------------------------------------------------------------------------------------
local function entrega4 ()
    if not (statusPrato4 == -1) then
        prato4:setSequence ("nada")
        jaComPao4 = false
        jaComAlface4 = false
        jaComBatata4 = false
        jaComTomate4 = false
        jaTemPrato4 = false
        statusPrato4 = -1
        if pratosNaPia == 3 then
            pia:setSequence ("4prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 2 then
            pia:setSequence ("3prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 1 then
            pia:setSequence ("2prato")
            pratosNaPia = pratosNaPia +1
        elseif pratosNaPia == 0 then
            pia:setSequence ("1prato")
            pratosNaPia = pratosNaPia +1
        end
    end
end

prato4:addEventListener ("tap", entrega4)

-- Função para lavar os pratos --------------------------------------------------------------------------------------------------
local function lavarPrato ()
    if pratosNaPia == 3 then
        pia:setSequence ("2prato")
        if pratoNoMonte == 3 then
            pratos:setSequence ("4pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 2 then
            pratos:setSequence ("3pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 1 then
            pratos:setSequence ("2pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 0 then
            pratos:setSequence ("1prato")
            pratoNoMonte = pratoNoMonte +1
        end
        pratosNaPia = pratosNaPia -1
    elseif pratosNaPia == 2 then
        pia:setSequence ("1prato")
        if pratoNoMonte == 3 then
            pratos:setSequence ("4pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 2 then
            pratos:setSequence ("3pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 1 then
            pratos:setSequence ("2pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 0 then
            pratos:setSequence ("1prato")
            pratoNoMonte = pratoNoMonte +1
        end
        pratosNaPia = pratosNaPia -1
    elseif pratosNaPia == 1 then
        print ("pratosnomonte".. pratoNoMonte)
        pia:setSequence ("nada")
        if pratoNoMonte == 3 then
            pratos:setSequence ("4pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 2 then
            pratos:setSequence ("3pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 1 then
            pratos:setSequence ("2pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 0 then
            pratos:setSequence ("1prato")
            pratoNoMonte = pratoNoMonte +1
        end
        pratosNaPia = pratosNaPia -1
    elseif pratosNaPia == 4 then
        pia:setSequence ("3prato")
        if pratoNoMonte == 3 then
            pratos:setSequence ("4pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 2 then
            pratos:setSequence ("3pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 1 then
            pratos:setSequence ("2pratos")
            pratoNoMonte = pratoNoMonte +1
        elseif pratoNoMonte == 0 then
            pratos:setSequence ("1prato")
            pratoNoMonte = pratoNoMonte +1
        end
        pratosNaPia = pratosNaPia -1
    end
end

-- Cria um ouvinte para a função de lavarPratos ---------------------------------------------------------------------------------
pia:addEventListener ("tap", lavarPrato)

-- Variável ---------------------------------------------------------------------------------------------------------------------
local valorPedido = -1
local valorPedido2 = -1
local valorPedido3 = -1
local valorPedido4 = -1
local pontos = 0
local pontosText = display.newText (grupoUI, "Pontos:" .. pontos, -170 + display.contentWidth + letterboxWidth, display.contentCenterY-140, native.systemFont, 20 )

pontosText:setFillColor (0, 0, 0)

-- Função que registra os pedidos que podem ser feitos --------------------------------------------------------------------------
local function registroDePedidos ()
    if valorPedido == statusPrato1 then
        pedidos:setSequence ("nada")
        valorPedido = -1
        pontos = pontos +100
        pontosText.text = "Pontos: " .. pontos
        entrega1 ()
        elseif valorPedido == 35 then
        pedidos:setSequence ("tomateEBatata")
    elseif valorPedido == 14 then
        pedidos:setSequence ("alfaceETomate")
    elseif valorPedido == 70 then
        pedidos:setSequence ("alfaceTomateEBatata")
    elseif valorPedido == 10 then
        pedidos:setSequence ("alfaceEBatata")
    elseif valorPedido == 42 then
        pedidos:setSequence ("paoDeAlfaceETomate")
    elseif valorPedido == 21 then
        pedidos:setSequence ("paoETomate")
    elseif valorPedido == 6 then
        pedidos:setSequence ("paoEAlface")
    end
    if valorPedido2 == statusPrato2 then
        pedidos2:setSequence ("nada")
        valorPedido2 = -1
        pontos = pontos +100
        pontosText.text = "Pontos: " .. pontos
        entrega2 ()
    elseif valorPedido2 == 35 then
        pedidos2:setSequence ("tomateEBatata")
    elseif valorPedido2 == 14 then
        pedidos2:setSequence ("alfaceETomate")
    elseif valorPedido2 == 70 then
        pedidos2:setSequence ("alfaceTomateEBatata")
    elseif valorPedido2 == 10 then
        pedidos2:setSequence ("alfaceEBatata")
    elseif valorPedido2 == 42 then
        pedidos2:setSequence ("paoDeAlfaceETomate")
    elseif valorPedido2 == 21 then
        pedidos2:setSequence ("paoETomate")
    elseif valorPedido2 == 6 then
        pedidos2:setSequence ("paoEAlface")
    end
    if valorPedido3 == statusPrato3 then
        pedidos3:setSequence ("nada")
        valorPedido3 = -1
        pontos = pontos +100
        pontosText.text = "Pontos: " .. pontos
        entrega3 ()
    elseif valorPedido3 == 35 then
        pedidos3:setSequence ("tomateEBatata")
    elseif valorPedido3 == 14 then
        pedidos3:setSequence ("alfaceETomate")
    elseif valorPedido3 == 70 then
        pedidos3:setSequence ("alfaceTomateEBatata")
    elseif valorPedido3 == 10 then
        pedidos3:setSequence ("alfaceEBatata")
    elseif valorPedido3 == 42 then
        pedidos3:setSequence ("paoDeAlfaceETomate")
    elseif valorPedido3 == 21 then
        pedidos3:setSequence ("paoETomate")
    elseif valorPedido3 == 6 then
        pedidos3:setSequence ("paoEAlface")
    end
    if valorPedido4 == statusPrato4 then
        pedidos4:setSequence ("nada")
        valorPedido4 = -1
        pontos = pontos +100
        pontosText.text = "Pontos: " .. pontos
        entrega4 ()
    elseif valorPedido4 == 35 then
        pedidos4:setSequence ("tomateEBatata")
    elseif valorPedido4 == 14 then
        pedidos4:setSequence ("alfaceETomate")
    elseif valorPedido4 == 70 then
        pedidos4:setSequence ("alfaceTomateEBatata")
    elseif valorPedido4 == 10 then
        pedidos4:setSequence ("alfaceEBatata")
    elseif valorPedido4 == 42 then
        pedidos4:setSequence ("paoDeAlfaceETomate")
    elseif valorPedido4 == 21 then
        pedidos4:setSequence ("paoETomate")
    elseif valorPedido4 == 6 then
        pedidos4:setSequence ("paoEAlface")
    end
end

Runtime:addEventListener ("enterFrame", registroDePedidos)

local segundosRestantes = 60  -- 10 minutos * 60 segundos

local relogioText = display.newText( "1:00", -70 + display.contentWidth + letterboxWidth, display.contentCenterY-140, native.systemFont, 20 )
relogioText:setFillColor( 0, 0, 0 )

local function atualizarTempo( event )

    -- Decrement the number of segundos
    segundosRestantes = segundosRestantes - 1

    -- Time is tracked in segundos; convert it to minutos and segundos
    local minutos = math.floor( segundosRestantes / 60 )
    local segundos = segundosRestantes % 60

    -- Make it a formatted string
    local timeDisplay = string.format( "%02d:%02d", minutos, segundos )

    -- Update the text object
    relogioText.text = timeDisplay
end

local contador = timer.performWithDelay( 1000, atualizarTempo, segundosRestantes )

local chamadoDoPedido

local function adicionarPedidos ()
    if valorPedido == -1 then
        chamadoDoPedido = math.random (1,7)
        if chamadoDoPedido == 1 then
            valorPedido = 35
        elseif chamadoDoPedido == 2 then
            valorPedido = 14
        elseif chamadoDoPedido == 3 then
            valorPedido = 70
        elseif chamadoDoPedido == 4 then
            valorPedido = 10
        elseif chamadoDoPedido == 5 then
            valorPedido = 42
        elseif chamadoDoPedido == 6 then
            valorPedido = 21
        elseif chamadoDoPedido == 7 then
            valorPedido = 6
        end
    elseif valorPedido2 == -1 then
        chamadoDoPedido = math.random (1,7)
        if chamadoDoPedido == 1 then
            valorPedido2 = 35
        elseif chamadoDoPedido == 2 then
            valorPedido2 = 14
        elseif chamadoDoPedido == 3 then
            valorPedido2 = 70
        elseif chamadoDoPedido == 4 then
            valorPedido2 = 10
        elseif chamadoDoPedido == 5 then
            valorPedido2 = 42
        elseif chamadoDoPedido == 6 then
            valorPedido2 = 21
        elseif chamadoDoPedido == 7 then
            valorPedido2 = 6
        end
    elseif valorPedido3 == -1 then
        chamadoDoPedido = math.random (1,7)
        if chamadoDoPedido == 1 then
            valorPedido3 = 35
        elseif chamadoDoPedido == 2 then
            valorPedido3 = 14
        elseif chamadoDoPedido == 3 then
            valorPedido3 = 70
        elseif chamadoDoPedido == 4 then
            valorPedido3 = 10
        elseif chamadoDoPedido == 5 then
            valorPedido3 = 42
        elseif chamadoDoPedido == 6 then
            valorPedido3 = 21
        elseif chamadoDoPedido == 7 then
            valorPedido3 = 6
        end
    elseif valorPedido4 == -1 then
        chamadoDoPedido = math.random (1,7)
        if chamadoDoPedido == 1 then
            valorPedido4 = 35
        elseif chamadoDoPedido == 2 then
            valorPedido4 = 14
        elseif chamadoDoPedido == 3 then
            valorPedido4 = 70
        elseif chamadoDoPedido == 4 then
            valorPedido4 = 10
        elseif chamadoDoPedido == 5 then
            valorPedido4 = 42
        elseif chamadoDoPedido == 6 then
            valorPedido4 = 21
        elseif chamadoDoPedido == 7 then
            valorPedido4 = 6
        end
    end
end

local nivel = 10
local tempoNivel = 0

local function level ()
    if nivel == 1 then
        tempoNivel = 600
    elseif nivel == 2 then
        tempoNivel = 300
    elseif nivel == 3 then
        tempoNivel = 200
    elseif nivel == 4 then
        tempoNivel = 180
    elseif nivel == 5 then
        tempoNivel = 160
    elseif nivel == 6 then
        tempoNivel = 140
    elseif nivel == 7 then
        tempoNivel = 120
    elseif nivel == 8 then
        tempoNivel = 100
    elseif nivel == 9 then
        tempoNivel = 75
    elseif nivel == 10 then
        tempoNivel = 50
    end
end

level ()

local time = 0

local function tempo ()
    time = time +1
    if time == tempoNivel then
        adicionarPedidos ()
        time = 0
    end
end

Runtime:addEventListener ("enterFrame", tempo)

local function endLevel ()
    if segundosRestantes == 0 then
        print ("cabo")
    end
end

Runtime:addEventListener ("enterFrame", endLevel)