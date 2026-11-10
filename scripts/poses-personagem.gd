class_name PosesPersonagem
extends AnimatedSprite2D

enum Direcao { BAIXO, LADO, CIMA }

const PARADO := [&"parado_baixo", &"parado_lado", &"parado_cima"]
const ANDANDO := [&"andar_baixo", &"andar_lado", &"andar_cima"]
const TOLERANCIA_DIAGONAL := 2.0

var direcao := Direcao.BAIXO


# Seleção de animação inspirada em scripts/player.gd do projeto de exemplo da disciplina.
func mostrar_movimento(movimento: Vector2) -> void:
	if movimento.length_squared() <= 4.0:
		if animation != PARADO[direcao]:
			play(PARADO[direcao])
		return

	var horizontal := absf(movimento.x)
	var vertical := absf(movimento.y)
	if horizontal > vertical + TOLERANCIA_DIAGONAL:
		direcao = Direcao.LADO
	elif vertical > horizontal + TOLERANCIA_DIAGONAL:
		direcao = Direcao.BAIXO if movimento.y > 0.0 else Direcao.CIMA

	if direcao == Direcao.LADO:
		flip_h = movimento.x > 0.0
	else:
		direcao = Direcao.BAIXO if movimento.y > 0.0 else Direcao.CIMA
		flip_h = false

	if animation != ANDANDO[direcao] or not is_playing():
		play(ANDANDO[direcao])
