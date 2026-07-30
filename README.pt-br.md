🇧🇷 Português | [🇺🇸 English](README.md)

<p align="center">
  <img src="assets/logo.png" alt="GQEngine Logo"/>
</p>

GQEngine é uma engine para criação de jogos 2D focada em simplicidade, modularidade e desenvolvimento por código. O projeto não possui um editor visual, incentivando o desenvolvedor a estruturar o seu jogo e compreender sua arquitetura desde o inicio.

Internamente, a engine utiliza **LuaJIT** e **SDL2**, oferecendo uma API simples e consistente para o desenvolvimento de jogos 2D.

## Filosofia
A GQEngine foi criada com alguns objetivos principais:

- API simples e fácil de aprender;
- Arquitetura modular baseada em plugins;
- Desenvolvimento totalmente por código;
- Pouca configuração para iniciar um projeto;
- Incentivar boas práticas de organização sem esconder o funcionamento da engine.

## Exemplo Básico

Abaixo está um exemplo mínimo de inicialização da engine com uma janela e desenho no canvas:

```lua
local gq = require("gqengine")
local GraphicsPlugin = require("gqengine.internal.graphics.graphics_plugin")

-- Habilita os plugins necessários
gq.enablePlugin(GraphicsPlugin())

-- Cria a janela e obtém o canvas ativo
local window = gq.createWindow("GQEngine - Exemplo Básico", 800, 600)
local canvas = window:getCanvas()

-- Define a lógica de desenho no canvas
function canvas:onRender(g)
    g.setColor(255, 0, 0)           -- Vermelho
    g.fillRect(100, 100, 200, 150)  -- Retângulo preenchido
    
    g.setColor(255, 255, 255)       -- Branco
    g.lineRect(100, 100, 200, 150)  -- Contorno do retângulo
end

-- Inicia o loop principal da engine
gq.run()
```

## Sistema de plugins
Grande parte das funcionalidades da engine é fornecida através de plugins independentes. Eles podem ser habilitados apenas quando necessários, mantendo cada projeto enxuto e modular.

Os plugins incluem:

- Máquina de estados
- Sistema de cenas
- Gerenciamento de assets
- Sistema de eventos (Signals)
- Save/Load
- Sistema de input configurável
- Timers
- Câmera

Novos plugins poderão utilizar licenças diferentes da licença principal da engine. Consulte o arquivo `LICENSE` para mais informações.

O sistema de plugins ainda está em desenvolvimento e sua API poderá sofrer alterações durante as primeiras versões.

## Plataformas
A GQEngine é desenvolvida e testada oficialmente em Linux, ambiente principal do projeto.

Como LuaJIT e SDL2 são multiplataformas, existe a expectativa de suporte para Windows e outras plataformas no futuro. No entanto, apenas Linux é considerado oficialmente suportado nesta fase inicial do desenvolvimento.

## Contribuindo
O projeto ainda está em fase inicial de desenvolvimento e sua arquitetura está sendo definida.

Sugestões, dúvidas e discussões são bem-vindas através das **Issues** e **Discussions** do repositório.

Contribuições do código ainda não estão sendo aceitas, mas isso deverá mudar conforme a engine amadurecer.
