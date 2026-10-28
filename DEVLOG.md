# DEVLOG

## Aula 08 — roteiro de 07/10/2026; implementação em 28/10/2026

O que fiz: cenário visto de cima, com muro e colisão, e personagem que anda nas quatro direções.
O que travou: a tecla A movia o personagem para a direita, e a seta esquerda funcionava normal. Eu achei que o script estivesse invertendo as direções, mas o problema estava no Input Map.
Como resolvi: o evento da tecla A tinha sido adicionado na ação right, não na left. Removi de right, adicionei em left e testei as quatro direções com seta e com WASD.

