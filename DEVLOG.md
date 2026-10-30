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