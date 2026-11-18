# River Jumper

Projeto de Jogos Digitais II, desenvolvido na Godot 4.7.1 com renderizador Compatibility.

## Carta do projeto

- **Tema:** beira de rio com piranhas saltadoras.
- **Tipo:** Resgate.
- **Modo:** horda, visto de cima; movimento em quatro direções, sem gravidade.
- **Objetivo:** encontrar 5 aliados, que passam a seguir o jogador em fila.
- **Derrota:** a vida acaba ou um inimigo toca a fila.

## Como jogar

**[Jogar River Jumper no navegador](https://allan357.github.io/river-jumper/)**

Abra o arquivo `project.godot` na Godot e pressione **F5**. Mova o personagem de colete amarelo com **WASD** ou com as **setas**. Pressione **Espaço** para atacar as piranhas no chão dentro do anel. Cada abate mostra **+1** no ponto do golpe e acrescenta um ícone de piranha ao HUD. Depois do quinto ícone, o HUD mostra quantos abates vieram a mais. Os corações mostram a vida restante.

Encoste nos **cinco aliados de azul** para resgatá-los. As posições dos aliados são sorteadas por todo o terreno livre a cada partida. Eles passam a seguir você em fila. Você vence ao reunir os cinco. Cada contato com uma piranha em terra tira uma vida. A partida termina se você perder as três vidas ou se uma piranha tocar um aliado que já está na fila. Pressione **Enter** na tela de vitória ou derrota para jogar novamente.

Os inimigos saltam do rio. Depois de pousar, dão três pulos em direção ao jogador, contornando as pedras, e desaparecem. Só os inimigos derrotados com o ataque contam no placar. Os vermelhos pousam em pontos livres sorteados no terreno. A cada cinco vermelhos, um verde salta para a posição que o jogador ocupava no início do salto. Mova-se antes de ele pousar para desviar.

![Arena do River Jumper com aliados em fila, corações de vida e ícones de piranha](aula-11.png)

## Referência do código

O script `scripts/jogador.gd` usa o exemplo [8-way movement da documentação oficial da Godot](https://docs.godotengine.org/en/stable/tutorials/2d/2d_movement.html#way-movement) para o movimento. A velocidade do jogador é 160 px/s.

A horda, o dano e o fim da partida seguem as Partes 1 a 4 do roteiro prático da Aula 09 de Jogos Digitais II. Consulte também [CharacterBody2D](https://docs.godotengine.org/en/stable/classes/class_characterbody2d.html), [Area2D](https://docs.godotengine.org/en/stable/classes/class_area2d.html), [Timer](https://docs.godotengine.org/en/stable/classes/class_timer.html) e [SceneTree](https://docs.godotengine.org/en/stable/classes/class_scenetree.html).

O salto usa [Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html#class-tween-method-tween-method). Os pulos em terra usam [move_and_collide()](https://docs.godotengine.org/en/stable/classes/class_physicsbody2d.html#class-physicsbody2d-method-move-and-collide) em modo de teste para calcular até onde o inimigo pode ir. O pouso aleatório usa [intersect_shape()](https://docs.godotengine.org/en/stable/classes/class_physicsdirectspacestate2d.html#class-physicsdirectspacestate2d-method-intersect-shape) para descartar pontos ocupados.

A navegação e o ataque seguem as Partes 1 e 2 do roteiro da Aula 10. A malha exclui os obstáculos da arena e o agente indica o próximo ponto para cada pulo. Consulte [NavigationPolygon](https://docs.godotengine.org/en/stable/classes/class_navigationpolygon.html) e [NavigationAgent2D](https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html).

O Resgate parte da ficha do roteiro da Aula 10, páginas 11–12. A fila usa o caminho já percorrido pelo jogador para espaçar os aliados e segue as colisões da arena.

Os sprites, as poses dos personagens e as texturas de referência do terreno foram gerados para o River Jumper com ImageGen e adaptados com auxílio do Codex.
