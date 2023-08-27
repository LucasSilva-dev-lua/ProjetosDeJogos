-- Variável global. (Deve ser evitado)
vidas = 2
vidas = 8
print (vidas)
print ("O valor de vidas:" .. vidas)
----------------
-- Variáveis locais (só é lida dentro do script)
-- (local) é utilizado somente na criação da variável
local pontos = 10
print (pontos)
print ("O valor de pontos: " .. pontos)

---------- Operações aritméticas ------------
-- Soma
-- local (significa que a variável é local) laranjas (nome da variável) = (atribuir valor) 10 (valor atribuído a variável)
local laranjas = 10

laranjas = laranjas + 5
-- print imprime a informação dentro do console
print (laranjas)

local bananas = 5

-- Soma entre variáveis 
local cesta = 0
cesta = laranjas + bananas
print ("A soma entre as variáveis laranjas e bananas é: " .. cesta)

print ("Na sua cesta possuem " .. cesta .. " frutas")

-- Subtração

cesta = laranjas - bananas
bananas = bananas - 1

-- Multiplicação

local carro = 8
carro = carro * 2
print ("Quantidade de carros: " .. carro)

-- Dividindo pela multiplicação
carro = carro * 0.5
print ("Divisão pela multiplicação: " .. carro)