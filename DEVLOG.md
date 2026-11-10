# DEVLOG

## Aula 08 — roteiro de 07/10/2026; implementação em 28/10/2026

O que fiz: cenário visto de cima, com muro e colisão, e personagem que anda nas quatro direções.
O que travou: a tecla A movia o personagem para a direita, e a seta esquerda funcionava normal. Eu achei que o script estivesse invertendo as direções, mas o problema estava no Input Map.
Como resolvi: o evento da tecla A tinha sido adicionado na ação right, não na left. Removi de right, adicionei em left e testei as quatro direções com seta e com WASD.

## Aula 09 — roteiro de 21/10/2026

O que fiz: adicionei a horda, três vidas e um cronômetro de 60 segundos, com telas de vitória e derrota.
O que travou: os inimigos apareciam em terra, o que não combinava com a ideia das piranhas saindo do rio. Também testei um salto em arco antes de trocar a animação.
Como resolvi: fiz os inimigos saírem da água e usei a mudança de tamanho para mostrar o salto. Depois de pousar, eles dão três pulos em terra e somem.
Teste: joguei com o dano ativo e consegui sobreviver aos 60 segundos.

## Aula 10 — roteiro de 28/10/2026

O que fiz: fiz as piranhas contornarem as pedras nos pulos em terra. Também adicionei o ataque com Espaço e o placar de abates.
O que travou: no primeiro teste, a rota vinha vazia porque eu consultava o mapa de navegação logo que a cena abria.
Como resolvi: passei a esperar o Godot carregar o mapa de navegação antes de consultar o caminho. Aí consegui verificar que a piranha dava a volta na pedra.
Teste: conferi o alcance e a recarga do ataque. A partida automatizada chegou aos 60 segundos com o dano ativo.

## Aula 11 — roteiro de 04/11/2026

O que fiz: coloquei os sprites do personagem, dos aliados e das piranhas na arena e troquei a vida do HUD por corações.
O que travou: mesmo reiniciando a partida, eu encontrava os aliados quase sempre nos mesmos lugares. Só mudava um pouco a posição de cada um.
Como resolvi: passei a sortear as posições em todo o terreno livre, com espaço entre os aliados e longe das pedras e do ponto inicial do jogador.
Teste: o jogo rodou por um minuto com a horda no ritmo máximo, sem travar.