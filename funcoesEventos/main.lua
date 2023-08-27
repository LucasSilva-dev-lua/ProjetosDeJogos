-- -- Incluuindo funções:
-- -- Comando para inicar a função local function nome da função seguido de parênteses
-- local function detectarTap (event) -- determina que a função é de evento.
--     -- Código que é executado quando o botão for tocado
--     -- tostring: para sequenciar
--     -- event.target: nomear o objeto do evento, ou objeto tocado.
--     print ("Objeto tocado: " .. tostring (event.target) )

--     return true -- "zera" todos os dados depois da função executada.

-- end -- Fecha a function 

-- local botaoTap = display.newRect (200, 200, 200, 50)
-- botaoTap:addEventListener ("tap", detectarTap)  -- Adidiona um ouvinte "tap" ao objeto.

-- local function tapDuplo (event)
--     -- se (número de taps do event for igual a 2) então
--     if (event.numTaps == 2 ) then
--         print ("Objeto tocado duas vezes: " ..tostring (event.target) )

--     else -- se não 
--         return true
--     end -- fecha o if/else
-- end -- fecha a function

-- local botaoDuplo = display.newRect (100, 300, 200, 50)
-- botaoDuplo:setFillColor (0.7, 0, 0.5)
-- botaoDuplo:addEventListener ("tap", tapDuplo)

-- -- Evento de toque (touch)
-- -- Fases de toque: 
--     -- began = Primeira fase de toque, quando o usuário encosta na tela.
--     -- moved = Quando o usuario mantém o toque e move pela tela.
--     -- ended = Quando o usuário retira o dedo na tela.
--     -- cancelled = Quando o evento de toque é cancelado do sistema.

-- local function fasesToque (event)
-- -- Se a fase de toque for igual a began então 
--     if (event.phase == "began" ) then
--         print ("Objeto tocado: " .. tostring(event.target) )
-- -- Pórem se a fase de toque for igual a moved então
--     elseif (event.phase == "moved" ) then
--         print ("Localização de toque nas seguintes coordenadas: x= " .. event.x .. ", y= " .. event.y)
-- -- Entretanto se a fase de toque for igual a ended ou cancelled então 
--     elseif (event.phase == "ended" or "cancelled" ) then
--         print ("Touch terminado no objeto: " .. tostring(event.target) )
--     end -- Fecha os ifs

--     return true
-- end -- Fecha a function

-- local botaoTouch = display.newRect (200, 400, 200, 50)
-- botaoTouch:setFillColor (0.9, 0.2, 0)
-- botaoTouch:addEventListener ("touch", fasesToque)
------------------------------------------------------------------------------------------------------------------------------------------------
-- Multitoque:
-- Para utilizar o multitouch precisamos habilitar (ativar) primeiro.
system.activate ("multitouch")

local retangulo = display.newRect ( display.contentCenterX, display.contentCenterY, 280, 440 )
retangulo:setFillColor (1, 0, 0.3)

local function eventoTouch (event)
    print ("Fase de toque: " .. event.phase )
    print ("Localização x: " .. tostring (event.x) .. ", localização y: " .. tostring(event.y) )
    print ("ID de toque exclusivo: " .. tostring(event.id) )
    print ("------------")
    return true
end

retangulo :addEventListener ("touch", eventoTouch)