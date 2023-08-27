local physics = require ("physics")
physics.start()
physics.setDrawMode ("normal")

display.setStatusBar (display.HiddenStatusBar)

local chao = display.newRect (display.contentCenterX, 470, 500, 50)
physics.addBody (chao, "static")

local paredeEsq = display.newRect (-10, display.contentCenterY, 50, 500)
physics.addBody(paredeEsq, "static")

local testeParticula = physics.newParticleSystem (
    {
        -- Nome do arquivo de partícula
        filename = "liquidParticle.png",
        -- radius físico da partícula
        radius= 2,
        -- radius da imagem (usar sempre valor menor que o radius da partícula para que elas se sobreponham e traga um efeito visual mais satisfatório.)
        imageRadius = 4
    }
)

local function onTimer (event)
    testeParticula:createParticle (
    { -- Determina onde a nova partícula é gerada.
        x= 0,
        y= 0,
        -- Valores iniciais de velocidade para a partícula.
        velocityX= 256,
        velocityY= 480,
        -- Define a cor da partícula RGBA (A= alpha)
        color= {1, 0.2, 0.4, 1},
        -- Define o tempo de vida da partícula, quantos segundos ela permanece na tela antes de "morer" (0 = infinito)
        lifeTime= 32.0,
        -- Define o comportamento da partícula.
        flags= {"water", "colorMixing"}
    })
end
timer.performWithDelay (20, onTimer, 0)

testeParticula:createGroup (
    {
        x=50,
        y=0,
        color={0, 0.3, 1, 1},
        -- Metade da largura do grupo
        halfWidth= 64,
        -- Metade da altura do grupo
        halfHeight = 32,
        flags ={"water", "colorMixing"}
    }
)
testeParticula:applyForce (0, -9.8*testeParticula.particleMass)


local paredeDir = display.newRect (320, display.contentCenterY, 50, 500)
physics.addBody (paredeDir, "static")

