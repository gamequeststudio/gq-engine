🇧🇷 Português | [🇺🇸 English](README.md)

<p align="center">
  <img src="assets/logo.png" alt="GQEngine Logo"/>
</p>

# GQEngine

GQEngine é uma engine para criação de jogos 2D focada em **simplicidade, modularidade e desenvolvimento por código**.

A engine não possui um editor visual. O desenvolvimento é realizado diretamente através de código Lua, permitindo que o desenvolvedor tenha controle explícito sobre a estrutura e o funcionamento do jogo.

Internamente, a GQEngine utiliza **LuaJIT** e **SDL2**, disponibilizando uma API de alto nível para as funcionalidades da engine sem expor diretamente os detalhes de implementação dessas bibliotecas.

## Filosofia

A GQEngine foi projetada com os seguintes objetivos:

* API simples e fácil de aprender;
* Arquitetura modular baseada em plugins;
* Desenvolvimento totalmente por código;
* Pouca configuração inicial;
* Separação entre API pública e implementação interna;
* Abstração das bibliotecas utilizadas pela engine sem ocultar conceitos fundamentais do desenvolvimento de jogos;
* Possibilidade de habilitar funcionalidades adicionais apenas quando necessárias.

## Exemplo básico

O exemplo abaixo cria uma janela e inicia o game loop da engine:

```lua
local gq = require("gqengine")

local window = gq.createWindow("My Game", 800, 600)

gq.run()
```

Funcionalidades adicionais, como renderização e gerenciamento de input, são fornecidas através de plugins externos.

## Arquitetura

A GQEngine utiliza uma arquitetura modular baseada em **plugins**.

A `Engine` é responsável pelo ciclo principal da aplicação, enquanto o `PluginManager` gerencia os plugins e distribui eventos do ciclo de vida para os sistemas registrados.

De forma simplificada:

```text
Engine
  │
  ├── PluginManager
  │      │
  │      ├── Internal Plugins
  │      │
  │      └── External Plugins
  │
  └── Public API
```

Os plugins podem manter seu estado interno separado da API pública, permitindo que detalhes de implementação não sejam expostos diretamente ao código do jogo.

### Plugins

Os plugins externos atualmente disponíveis incluem:

* **GraphicsPlugin** — renderização 2D, formas geométricas, Canvas e transformações;
* **InputPlugin** — sistema de input baseado em ações e suporte a teclado;
* **ScenesPlugin** — gerenciamento de cenas e ciclo de vida.

A engine também possui plugins internos utilizados para fornecer funcionalidades essenciais, como o gerenciamento da janela SDL2.

Plugins externos podem ser habilitados apenas quando necessários, mantendo a estrutura do projeto modular.

O sistema de plugins ainda está em desenvolvimento e sua API poderá sofrer alterações durante as primeiras versões.

## Renderização

O `GraphicsPlugin` fornece uma API de renderização 2D independente da API diretamente exposta pelo SDL2.

Entre os recursos disponíveis estão:

* Desenho de retângulos;
* Desenho de linhas;
* Desenho e preenchimento de polígonos;
* Desenho e preenchimento de círculos;
* Transformações de translação, rotação e escala;
* Pilha de transformações com `push` e `pop`;
* Canvas;
* Desenho de Canvas com escala.

A renderização utiliza SDL2 internamente, mas os objetos e operações disponíveis ao jogo são abstraídos pela API da GQEngine.

## Input

O `InputPlugin` fornece um sistema de input baseado em ações.

As ações podem ser associadas a teclas e consultadas através de diferentes estados:

```lua
gq.isActionPressed("jump")
gq.isActionJustPressed("jump")
gq.isActionReleased("jump")
```

O sistema atualmente possui suporte a teclado, com suporte a outros dispositivos planejado para versões futuras.

## Cenas

O `ScenesPlugin` fornece um sistema básico de gerenciamento de cenas.

Uma cena pode implementar callbacks de ciclo de vida como:

```lua
function scene:onEnter()
end

function scene:onUpdate(dt)
end

function scene:onRender(graphics)
end

function scene:onLeave()
end
```

As cenas são responsáveis por organizar a lógica e a renderização de diferentes partes do jogo.

## Plataformas

A GQEngine é desenvolvida e testada oficialmente em **Linux**, que atualmente é a plataforma principal do projeto.

Como a engine utiliza LuaJIT e SDL2, sua arquitetura não é limitada conceitualmente ao Linux. O suporte oficial a Windows e outras plataformas poderá ser adicionado futuramente.

Neste estágio, **Linux é a única plataforma oficialmente suportada**.

## Dependências

As principais dependências utilizadas pela engine são:

* [LuaJIT](https://luajit.org/)
* [SDL2](https://www.libsdl.org/)

A comunicação com SDL2 é realizada através do binding utilizado pela engine.

## Estado do projeto

A arquitetura inicial da GQEngine já está definida e uma primeira versão funcional dos principais sistemas está em desenvolvimento.

A engine ainda está em uma fase inicial e APIs, estruturas internas e sistemas existentes poderão sofrer alterações conforme o projeto evolui.

## Contribuindo

Sugestões, dúvidas e discussões são bem-vindas através das **Issues** e **Discussions** do repositório.

Contribuições de código ainda não estão sendo aceitas neste momento. Essa política poderá mudar conforme a engine amadurecer e suas APIs se tornarem mais estáveis.

## Licença

Consulte o arquivo `LICENSE` para obter informações sobre os termos de distribuição e utilização da GQEngine.

Os plugins atualmente incluídos no repositório fazem parte do projeto da engine e estão sujeitos à licença definida para este projeto.

Plugins desenvolvidos e distribuídos separadamente poderão possuir seus próprios termos de licenciamento. Nesses casos, consulte a documentação e os arquivos de licença fornecidos junto ao respectivo plugin.

