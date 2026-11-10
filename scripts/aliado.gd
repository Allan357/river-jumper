extends CharacterBody2D

const VELOCIDADE := 185.0

var indice_fila := -1
@onready var arena := get_tree().current_scene
@onready var corpo: PosesPersonagem = $Corpo
@onready var detector: Area2D = $Detector


# Recrutamento e perda da fila adaptados da ficha de Resgate do roteiro da Aula 10.
func _on_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("inimigo"):
		if indice_fila >= 0:
			arena.perder()
	elif indice_fila == -1 and body.is_in_group("player"):
		arena.resgatar(self)
		if indice_fila >= 0:
			for presente in detector.get_overlapping_bodies():
				if presente.is_in_group("inimigo"):
					arena.perder()
					break


# Segue o rastro do jogador com espaçamento por aliado; desvio com NavigationServer2D e Codex.
func _physics_process(delta: float) -> void:
	if indice_fila < 0 or arena.partida_encerrando:
		return

	var destino: Vector2 = arena.ponto_da_fila(indice_fila)
	if global_position.distance_squared_to(destino) <= 1.0:
		corpo.mostrar_movimento(Vector2.ZERO)
		return

	if test_move(global_transform, destino - global_position):
		var mapa := get_world_2d().navigation_map
		if NavigationServer2D.map_get_iteration_id(mapa) > 0:
			var rota := NavigationServer2D.map_get_path(mapa, global_position, destino, true)
			if rota.size() > 1:
				destino = rota[0] if global_position.distance_squared_to(rota[0]) > 16.0 else rota[1]

	velocity = (global_position.move_toward(destino, VELOCIDADE * delta) - global_position) / delta
	move_and_slide()
	corpo.mostrar_movimento(get_real_velocity())
