extends Node2D

const CENA_INIMIGO := preload("res://entities/inimigo.tscn")

var partida_encerrando := false
var vermelhos_lancados := 0

@onready var jogador := $Jogador
@onready var terreno: ColorRect = $Terreno/Areia1
@onready var origem_saltos: Marker2D = $OrigemSaltos
@onready var horda: Timer = $Horda
@onready var relogio: Timer = $Relogio
@onready var texto_vida: Label = $HUD/Vida
@onready var texto_tempo: Label = $HUD/Tempo


# Placar adaptado do roteiro prático da Aula 09, Parte 4.
func _process(_delta: float) -> void:
	texto_vida.text = "Vida: %d" % jogador.vida
	texto_tempo.text = "Tempo: %d s" % ceili(relogio.time_left)


# Cadência baseada no roteiro da Aula 09, Parte 2; saltos e sequência 5:1 implementados com o Codex.
func _on_horda_timeout() -> void:
	horda.start(maxf(0.5, horda.wait_time * 0.95))
	var inimigo := CENA_INIMIGO.instantiate() as CharacterBody2D
	var verde := vermelhos_lancados == 5
	var destino: Vector2 = jogador.global_position
	if not verde:
		var colisor: CollisionShape2D = inimigo.get_node("CollisionShape2D")
		var forma := colisor.shape as RectangleShape2D
		destino = _sortear_pouso(forma, inimigo.collision_mask)
		if destino == Vector2.INF:
			inimigo.free()
			return

	inimigo.position = to_local(Vector2(origem_saltos.global_position.x, destino.y))
	add_child(inimigo)
	inimigo.saltar(destino, verde)
	vermelhos_lancados = 0 if verde else vermelhos_lancados + 1


# Sorteio implementado com o Codex usando intersect_shape(), da documentação oficial da Godot.
func _sortear_pouso(forma: RectangleShape2D, mascara: int) -> Vector2:
	var folga := maxf(forma.size.x, forma.size.y) / 2.0 + 1.0
	var area := terreno.get_global_rect().grow(-folga)
	var consulta := PhysicsShapeQueryParameters2D.new()
	consulta.shape = forma
	consulta.collision_mask = mascara
	var espaco := get_world_2d().direct_space_state

	for tentativa in range(16):
		var ponto := Vector2(randf_range(area.position.x, area.end.x),
			randf_range(area.position.y, area.end.y))
		consulta.transform = Transform2D(0.0, ponto)
		if espaco.intersect_shape(consulta, 1).is_empty():
			return ponto

	return Vector2.INF


# Encerramento adaptado do roteiro prático da Aula 09, Parte 4, com assistência do Codex.
func vencer() -> void:
	_agendar_fim()


func perder() -> void:
	_agendar_fim()


func _agendar_fim() -> void:
	if partida_encerrando:
		return

	partida_encerrando = true
	horda.stop()
	relogio.stop()
	_encerrar.call_deferred()


func _encerrar() -> void:
	if jogador.vida <= 0:
		get_tree().change_scene_to_file("res://scenes/derrota.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")
