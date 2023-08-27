local physics= require ('physics')
physics.start ()
physics.setGravity (0,9.8)
physics.setDrawMode ("hybrid")

display.setStatusBar (display.HiddenStatusBar)

local joint

local bodies = {}  -- String/tabela para armazenamento dos corpos.
local bodiesGroup = display.newGroup ()
local joints = {} -- String/tabela para armazenamento das juntas.

-- local staticBox = display.newRect (0,0,60,60)
-- staticBox: setFillColor (0.2,0.2,1)
-- physics.addBody (staticBox, "static", {isSensor=true})
-- staticBox.x,staticBox.y= display.contentCenterX,80

-- local shape = display.newRect (0,0,40,100)
-- shape: setFillColor (1,0.2,0.4)
-- physics.addBody (shape,"dynamic")
-- shape.x,shape.y,shape.rotation= 100,staticBox.y-40,0 

-- -- Criação da junta de pivô ("tipo de junta", objA, objB, ancoraX, ancoraY )
-- local jointPivot= physics.newJoint ("pivot",staticBox, shape, staticBox.x, staticBox.y)
-- jointPivot.isMotorEnabled= true -- Ativa o motor da junta de pivô
-- jointPivot.motorSpeed = 40 -- Define a velocidade do torque do motor.
-- jointPivot.maxMotorTorque= 1000 -- Define o valor máximo da velocidade do torque do motor, utilizado para melhor visualização do efeito.
-- jointPivot.isLimitEnabled = true -- Determina como ativado os limites de rotação.
-- jointPivot: setRotationLimits (-60,125)
----------------------------------------------------------------------------------------------------------------------------------------
-- Junta de distância 
-- local staticBox = display.newRect (0,0,60,60)
-- staticBox: setFillColor (0.2,0.2,1)
-- physics.addBody (staticBox, "static", {isSensor=true})
-- staticBox.x, staticBox.y=200,180

-- local shape = display.newRect (0,0,40,100)
-- shape: setFillColor (1,0.2,0.4)
-- physics.addBody (shape,"dynamic")
-- shape.x,shape.y = 200,80

-- ("tipo de junta", objA, objB, ancoraObjA.x, ancoraObjA.y, ancoraObjB.x, ancoraObjB.y)
-- local jointDistance = physics.newJoint ("distance", staticBox, shape, staticBox.x, staticBox.y-10, shape.x, shape.y)
-- jointDistance.frequency = 0.8  -- Define a frequência de amortecimento em Hz, quanto maior o valor mais macio.
-- jointDistance.dampingRatio = 0.8 -- Nível de amortecimento, onde 1 é amortecimento crítico.
-- jointDistance.length = staticBox.y - shape.y -- Define a distância entre os pontos de ancoragem.

-- shape:applyLinearImpulse (0.3,0,shape.x,shape.y-5)
------------------------------------------------------------------------------------------------------------------------------------------

-- Junta do pistão
-- local staticBox = display.newRect (0, 0, 60, 60)
-- staticBox:setFillColor (0.2, 0.2, 1)
-- physics.addBody (staticBox, "static", {isSensor=true})
-- staticBox.x, staticBox.y = display.contentCenterX, 360

-- local shape = display.newRect (0, 0, 140, 30)
-- shape:setFillColor (1, 0.2, 0.4)
-- physics.addBody (shape, "dynamic", {bounce=1})
-- shape.x, shape.y = display.contentCenterX, 310

-- Criação da junta de pistão ("tipo de junta", objA, objB, ancoraX, ancoraY, eixoX, eixoY)
-- local jointPiston = physics.newJoint ("piston", staticBox, shape, shape.x, shape.y, 0, 1)

-- jointPiston.isMotorEnabled = true -- Habilita o motor da junta
-- jointPiston.motorSpeed = -30 -- Define a velocidade do motor (valor negativo faz a movimentação inversa)
-- jointPiston.maxMotorForce = 1000 -- Define o valor máximo da força do motor
-- jointPiston.isLimitEnabled = true -- Define que a junta possui limites de movimentação.
-- jointPiston:setLimits (-140, 0) -- Define os limites de movimentação positiva e negativa. Primeiro um valor negativo e depois positivo. Primeiro valor precisa ser menor ou igual ao segundo.
------------------------------------------------------------------------------------------------------------------------------------------
-- Junta de fricção

-- bodiesGroup.alpha = 0 -- Define que todos os elementos do grupo possuem alfa 0
-- transition.to (bodiesGroup, {time=600, alpha=1, transition=easing.outQuad}) -- Transição do grupo para o alfa 1 em 600 milisegundos com efeito out Quad

-- local shape1 = display.newRect (bodiesGroup, 0, 0, 40, 40)
-- shape1:setFillColor (1, 0.2, 0.4)
-- physics.addBody (shape1, "dynamic")
-- shape1.x, shape1.y, shape1.rotation = display.contentCenterX-60, 170, 0
-- shape1.angularVelocity = 200 -- Adiciona um impulso angular ao shape (rotação ao redor do próprio eixo)
-- bodies [#bodies+1] = shape1 -- Adiciona o shape a tabela/string bodiea sem sobrescrever

-- local shape2 = display.newRect (bodiesGroup, 0, 0, 40, 40)
-- shape2:setFillColor (1, 0.2, 0.4)
-- physics.addBody (shape2, "dynamic")
-- shape2.x, shape2.y, shape2.rotation = display.contentCenterX+60, 170, 0
-- shape2.angularVelocity = 200 -- -- Adiciona um impulso angular ao shape (rotação ao redor do próprio eixo)
-- bodies [#bodies+1] = shape2 -- Adiciona o shape a tabela/string bodiea sem sobrescrever

-- local dirtField = display.newRect (bodiesGroup, 0, 0, 120, 190)
-- dirtField.type = "dirt"
-- dirtField:setFillColor (0.4, 0.25, 0.2)
-- physics.addBody (dirtField, "static", {isSensor=true})
-- dirtField.x, dirtField.y = display.contentCenterX-60, 335
-- bodies [#bodies+1] = dirtField

-- local grassField = display.newRect (bodiesGroup, 0, 0, 120, 190)
-- grassField.type = "grass"
-- grassField:setFillColor (0.1, 0.4, 0.3)
-- physics.addBody (grassField, "static", {isSensor=true})
-- grassField.x, grassField.y = display.contentCenterX+60, 335
-- bodies [#bodies+1] = grassField
-- bodiesGroup.alpha = 0 

-- local function handleCollision (self, event)
--    if (event.phase == "began") then
-- -- Cria duas variáveis para armazenar limite de força e torque
--        local forceLimit = 0
--        local torqueLimit = 0
-- -- Se o tipo do outro objeto colidido for ... então
--        if (event.other.type == "dirt") then
--        -- Altera os valores limites de força e torque
--            forceLimit = 0.22
--            torqueLimit = 0.022
--        -- Se não
--        else
--        -- Altera para outros valores.
--            forceLimit = 0.28
--           torqueLimit = 0.028
--        end
--        -- Cria um timer com função temporária para criação das juntas 10 milisegundos após a colisão
--        timer.performWithDelay (10,
--                function ()
--            -- Cria-se a junta já dentro da string joints, onde o objA é o colidido e o B o ouvinte da função, e as âncoras são criadas de acordo com a localização do objB.
--                    joints[#joints+1]= physics.newJoint ("friction", event.other, self, self.x, self.y)
--                -- Alteta os valores máximos de força e torque de acordo com o obtido no if acima.
--                    joints[#joints].maxForce = forceLimit
--                    joints[#joints].maxTorque = torqueLimit
--                end -- Fecha a function do timer.
--                ) -- Fecha o timer
--    end-- Fecha o if began
-- end -- Fecha a function

-- shape1.collision = handleCollision
-- shape1:addEventListener ("collision", shape1)

-- shape2.collision = handleCollision
-- shape2:addEventListener ("collision", shape2)
------------------------------------------------------------------------------------------------------------------------------------------
-- local bg = display.newImageRect("imagens/espaco.png", 1280/1.5, 800/1.5)
-- bg.x, bg.y = display.contentCenterX, display.contentCenterY

-- local sol = display.newImageRect ("imagens/Sol.png", 518/5, 482/5)
-- physics.addBody (sol, "static", {isSensor=true})
-- sol.x, sol.y = 170, 150

-- local mercurio = display.newImageRect ("imagens/mercurio.png", 474/5, 316/5)
-- physics.addBody (mercurio, "dynamic", {isSensor=true})
-- mercurio.x, mercurio.y = 170, 280

-- local jointPivot= physics.newJoint ("pivot",sol, mercurio, sol.x, sol.y)
-- jointPivot.isMotorEnabled= true -- Ativa o motor da junta de pivô
-- jointPivot.motorSpeed = 40 -- Define a velocidade do torque do motor.
-- jointPivot.maxMotorTorque= 1000 -- Define o valor máximo da velocidade do torque do motor, utilizado para melhor visualização do efeito.

-- local nave = display.newImageRect ("imagens/nave.png", 499/3, 499/3)
-- nave.x, nave.y = 450, 400
-- transition.to (nave, {timer= 3000, x=-100})
------------------------------------------------------------------------------------------------------------------------------------------
-- Junta de solda
-- local shape = display.newRect (0, 0, 60, 60)
-- shape:setFillColor (1, 0.2, 0.4)
-- physics.addBody (shape, "dynamic", {bounce=1})
-- shape.x, shape.y = display.contentCenterX-10, 230

-- local welded = display.newRect (0, 0, 60, 60)
-- welded:setFillColor (0.6, 0.1, 0.7)
-- physics.addBody (welded, "dynamic", {bounce=1})
-- welded.x, welded.y = display.contentCenterX+40, 180
-- welded.rotation = -25

-- local staticBox = display.newRect (0, 0, display.contentWidth-40, 50)
-- staticBox:setFillColor (0.2, 0.2, 1)
-- physics.addBody (staticBox, "static")
-- staticBox.x, staticBox.y = display.contentCenterX, 420

-- local jointWeld = physics.newJoint ("weld", welded, shape, shape.x, shape.y)
-- jointWeld.dampingRatio = 0.1
-- jointWeld.frequency = 0.1
------------------------------------------------------------------------------------------------------------------------------------------
-- Junta de roda

--local vehicleBody = display.newRect (bodiesGroup, 0, 0, 110, 20)
--vehicleBody:setFillColor (0.6, 0.1, 0.7)
--physics.addBody (vehicleBody, "dynamic")
--vehicleBody.x, vehicleBody.y = display.contentCenterX-50, 330
--vehicleBody.isFixedRotation = true
--bodies [#bodies+1] = vehicleBody

--local wheelA = display.newCircle (bodiesGroup, 0, 0, 15)
--wheelA:setFillColor (1, 0.2, 0.4)
--physics.addBody (wheelA, "dynamic", {bounce=0.5, friction=0.8, radius=15})
--wheelA.x, wheelA.y = vehicleBody.x-35, vehicleBody.y+30
--bodies [#bodies+1] = wheelA

--local wheelB = display.newCircle (bodiesGroup, 0, 0, 15)
--wheelB:setFillColor (1, 0.2, 0.4)
--physics.addBody (wheelB, "dynamic", {bounce=0.5, friction=0.8, radius=15})
--wheelB.x, wheelB.y = vehicleBody.x, vehicleBody.y+30
--bodies [#bodies+1] = wheelB

--local wheelC = display.newCircle (bodiesGroup, 0, 0, 15)
--wheelC:setFillColor (1, 0.2, 0.4)
--physics.addBody (wheelC, "dynamic", {bounce=0.5, friction=0.8, radius=15})
--wheelC.x, wheelC.y = vehicleBody.x+35, vehicleBody.y+30
--bodies [#bodies+1] = wheelC

--local staticBox = display.newRect (bodiesGroup, 0, 0, display.contentWidth-40, 50)
--staticBox:setFillColor (0.2, 0.2, 1)
--physics.addBody (staticBox, "static", {bounce=0, friction=1})
--staticBox.x, staticBox.y = display.contentCenterX, 420
--bodies [#bodies+1] = staticBox

--local bumperA = display.newRect (bodiesGroup, 0, 0, 30, 20)
--bumperA:setFillColor (0.2, 0.2, 1)
--physics.addBody (bumperA, "static", {bounce=1, friction=0})
--bumperA.x, bumperA.y = staticBox.x-staticBox.width/2+15, 385
--bodies [#bodies+1] = bumperA

--local bumperB = display.newRect (bodiesGroup, 0, 0, 30, 20)
--bumperB:setFillColor (0.2, 0.2, 1)
--physics.addBody (bumperB, "static", {bounce=1, friction=0})
--bumperB.x, bumperB.y = staticBox.x+staticBox.width/2-15, 385
--bodies [#bodies+1] = bumperB

-- -- Criação das variáveis para armazenamento dos parâmetros de frequência e DampingRatio
--local springFrequency = 30
--local springDampingRatio = 1.0

-- -- Criação da junta já dentro da string joints ([#joints+1] faz com que a variável não seja sobrescrita)
--joints[#joints+1] = physics.newJoint ("wheel", vehicleBody, wheelA, wheelA.x, wheelA.y, 1, 1)
-- -- Atribui a frequência e damping a junta dos valores já criados anteriormente.
--joints[#joints].springFrequency = springFrequency
--joints[#joints].springDampingRatio = springDampingRatio

--joints[#joints+1] = physics.newJoint ("wheel", vehicleBody, wheelB, wheelB.x, wheelB.y, 1, 1)
--joints[#joints].springFrequency = springFrequency
--joints[#joints].springDampingRatio = springDampingRatio

--joints[#joints+1] = physics.newJoint ("wheel", vehicleBody, wheelC, wheelC.x, --wheelC.y, 1, 1)
--joints[#joints].springFrequency = springFrequency
--joints[#joints].springDampingRatio = springDampingRatioz

-- -- Aplicação de torque às rodas para movimentação do carro.
--wheelA:applyTorque (2)
--wheelB:applyTorque (2)
--wheelC:applyTorque (2)
------------------------------------------------------------------------------------------------------------------------------------------
-- Junta da polia:
local bodyA = display.newCircle (bodiesGroup, 0, 0, 40)
bodyA:setFillColor (1, 0.2, 0.4)
physics.addBody (bodyA, "dynamic", {bounce=0.8, radius=40})
bodyA.x, bodyA.y = display.contentCenterX-50, 260
bodies[#bodies+1] = bodyA

local bodyB = display.newCircle (bodiesGroup, 0, 0, 26)
bodyB:setFillColor (1, 0.2, 0.4)
physics.addBody (bodyB, "dynamic", {bounce=0.8, radius=26})
bodyB.x, bodyB.y = display.contentCenterX+50, 300
bodies[#bodies+1] = bodyB

local staticBox = display.newRect (bodiesGroup, 0, 0, display.contentWidth-40, 50)
staticBox:setFillColor (0.2, 0.2, 1)
physics.addBody (staticBox, "static", {bounce=0.8})
staticBox.x, staticBox.y = display.contentCenterX, 420
bodies[#bodies+1] = staticBox

-- Criando a junta ("tipo de junta", corpoA, corpoB, pinoA.x, pinoA.y, pinoB.x, pinoB.y, ancoraA.x, ancoraA.y, ancoraB.x, ancoraB.y)
local joint = physics.newJoint ("pulley", bodyA, bodyB, bodyA.x, bodyA.y-100, bodyB.x, bodyB.y-140, bodyA.x, bodyA.y, bodyB.x, bodyB.y, 1.0)

