extends CharacterBody2D

const COR_VERDE := Color(0.28, 0.85, 0.38)
const DURACAO_SALTO := 0.8
const PAUSA_NO_CHAO := 0.35
const PULOS_NO_TERRENO := 3
const DISTANCIA_PULO := 48.0
const ESCALA_INICIAL := 0.55
const ESCALA_PICO := 1.35

@onready var corpo: ColorRect = $Corpo


# Pulos no terreno implementados com o Codex usando move_and_collide(), da documentação oficial da Godot.
func saltar(destino: Vector2, verde: bool) -> void:
	if verde:
		corpo.color = COR_VERDE

	await _pular_ate(destino)

	for _pulo in range(PULOS_NO_TERRENO):
		await get_tree().create_timer(PAUSA_NO_CHAO, false, true).timeout
		var jogador := get_tree().get_first_node_in_group("player") as Node2D
		if jogador == null:
			queue_free()
			return

		var origem := global_position
		var passo := origem.move_toward(jogador.global_position, DISTANCIA_PULO) - origem
		var colisao := move_and_collide(passo, true)
		if colisao != null:
			passo = colisao.get_travel()
		await _pular_ate(origem + passo)

	await get_tree().create_timer(PAUSA_NO_CHAO, false, true).timeout
	queue_free()


# Animação por escala implementada com o Codex usando Tween.tween_method(), da documentação oficial da Godot.
func _pular_ate(destino: Vector2) -> void:
	var camada := collision_layer
	var mascara := collision_mask
	collision_layer = 0
	collision_mask = 0

	var origem := global_position
	corpo.scale = Vector2.ONE * ESCALA_INICIAL
	var salto := create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	salto.tween_method(_animar_salto.bind(origem, destino), 0.0, 1.0, DURACAO_SALTO)
	await salto.finished

	global_position = destino
	corpo.scale = Vector2.ONE
	collision_layer = camada
	collision_mask = mascara


func _animar_salto(progresso: float, origem: Vector2, destino: Vector2) -> void:
	global_position = origem.lerp(destino, progresso)
	var escala: float
	if progresso < 0.5:
		escala = lerpf(ESCALA_INICIAL, ESCALA_PICO, progresso * 2.0)
	else:
		escala = lerpf(ESCALA_PICO, 1.0, progresso * 2.0 - 1.0)
	corpo.scale = Vector2.ONE * escala
