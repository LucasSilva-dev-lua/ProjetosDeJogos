local Teclado = {} -- Armazena todos os dados do script

function Teclado.novo (player)

    local function verificarTecla (event)
        -- se a fase de evento for down (tecla pressionada) então
        if event.phase == "down" then
            -- se a tecla pressionada for o d então
            if event.keyName == "d" then
                player.direcao = "direita"
                player:setSequence ("correndo")
                player:play()
                player.xScale = 1
            elseif event.keyName == "a" then
                player.direcao = "esquerda"
                player:setSequence ("correndo")
                player:play()
                player.xScale = -1
            elseif event.keyName == "space" then
                player.numeroPulo = player.numeroPulo + 1
                -- se numeroPulo for igual a 1 então
                    if player.numeroPulo == 1 then
                        -- é aplicado impulso linear no player (y)
                        player:applyLinearImpulse (0, -0.4, player.x, player.y)
                        -- se o numeroPulo for igual a 2 então
                    elseif player.numeroPulo == 2 then
                        -- transição para que o player gire 360 graus em torno do próprio eixo.
                        transition.to (player, {rotation=player.rotation+360, time=750})
                        player:applyLinearImpulse (0, -0.4, player.x, player.y)
                    end
            end
            -- quando a fase de evento for up (soltarmos a tecla) então
        elseif event.phase == "up" then
            if event.keyName == "d" then
                player.direcao = "parado"
                player:setSequence("parado")
                player:play()
            elseif event.keyName == "a" then
                player.direcao = "parado"
                player:setSequence("parado")
                player:play()
            end
        end
    end
    -- "key": teclado
    Runtime:addEventListener ("key", verificarTecla)
    
    -- função para movimentação
    local function verificarDirecao ()
        -- Retorna os valores de velocidade
        local velocidadeX, velocidadeY = player:getLinearVelocity ()
        -- print ("Velocidadex: " .. velocidadeX .. "velocidade Y: " .. velocidadeY)
        -- se a direção do player for direita e a velocidade x for menor ou igual a 200 then
        if player.direcao == "direita" and velocidadeX <= 200 then
            -- aplicado impulso linear para movimentação x direita.
            player:applyLinearImpulse (0.2, 0, player.x, player.y)
        elseif player.direcao == "esquerda" and velocidadeX >= -200 then
            player:applyLinearImpulse (-0.2, 0, player.x, player.y)
        end
    end
    -- "enterFrame" - executa a função o número de fps/s (nesse caso 60x por segundos)
    Runtime:addEventListener ("enterFrame", verificarDirecao)
end

return Teclado -- "fechar string teclado"
