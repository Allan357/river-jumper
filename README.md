# River Jumper

Projeto de Jogos Digitais II, desenvolvido na Godot 4.7.1 com renderizador Compatibility.

## Carta do projeto

- **Tema:** beira de rio com piranhas saltadoras.
- **Tipo:** Resgate.
- **Modo:** horda, visto de cima; movimento em quatro direções, sem gravidade.
- **Objetivo final:** encontrar 5 aliados, que passam a seguir o jogador em fila.
- **Derrota prevista:** a vida acaba ou um inimigo toca a fila.

## Como jogar

Abra o arquivo `project.godot` na Godot e pressione **F5**. Mova o quadrado amarelo com **WASD** ou com as **setas**. Pressione **Espaço** para acertar inimigos no chão ao seu redor. Cada inimigo atingido conta como um abate.

Nesta etapa, o objetivo é sobreviver **60 segundos**. Cada contato com um inimigo em terra tira uma vida, e a partida termina se você perder as três. Pressione **Enter** na tela de vitória ou derrota para jogar novamente.

Os inimigos saltam do rio. Depois de pousar, dão três pulos em direção ao jogador, contornando as pedras, e desaparecem. Só os inimigos derrotados com o ataque contam no placar. Os vermelhos pousam em pontos livres sorteados no terreno. A cada cinco vermelhos, um verde salta para a posição que o jogador ocupava no início do salto. Mova-se antes de ele pousar para desviar.

![Arena do River Jumper com clarão do ataque, inimigos e placar de abates](aula-10.png)

## Referência do código

O script `scripts/jogador.gd` usa o exemplo [8-way movement da documentação oficial da Godot](https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html#way-movement) para o movimento. A velocidade do jogador é 160 px/s.

A horda, o dano e o fim da partida seguem as Partes 1 a 4 do roteiro prático da Aula 09 de Jogos Digitais II. Consulte também [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html), [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html), [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) e [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html).

O salto usa [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-tween-method). Os pulos em terra usam [move_and_collide()](https://docs.godotengine.org/en/stable/classes/class_physicsbody2d.html#class-physicsbody2d-method-move-and-collide) em modo de teste para calcular até onde o inimigo pode ir. O pouso aleatório usa [intersect_shape()](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html#class-physicsdirectspacestate2d-method-intersect-shape) para descartar pontos ocupados.

A navegação e o ataque seguem as Partes 1 e 2 do roteiro da Aula 10. A malha exclui os obstáculos da arena e o agente indica o próximo ponto para cada pulo. Consulte [NavigationPolygon](https://docs.godotengine.org/en/stable/classes/class_navigationpolygon.html) e [NavigationAgent2D](https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html).

A adaptação e a configuração do projeto tiveram assistência do Codex.
