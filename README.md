# River Jumper

Projeto de Jogos Digitais II, desenvolvido na Godot 4.7.1 com renderizador Compatibility.

## Carta do projeto

- **Tema:** beira de rio com piranhas saltadoras.
- **Tipo:** Resgate.
- **Modo:** horda, visto de cima; movimento em quatro direções, sem gravidade.
- **Objetivo final:** encontrar 5 aliados, que passam a seguir o jogador em fila.
- **Derrota prevista:** a vida acaba ou um inimigo toca a fila.

## Referência do código

O script `scripts/jogador.gd` segue o exemplo **8-way movement** da [documentação oficial da Godot — 2D movement overview](https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html#way-movement), com `get_input()`, `Input.get_vector()` e `move_and_slide()`. A velocidade foi configurada como 160 na cena do jogador, mantendo o valor padrão 400 do exemplo no script.

A adaptação e a configuração do projeto tiveram assistência do Codex.
