extends CharacterBody2D

enum Estado { NO_CHAO, SAINDO_DO_RIO, PULANDO_EM_TERRA, ENCERRADO }

const COR_VERDE := Color(0.28, 0.85, 0.38)
const DURACAO_SALTO := 0.8
const PAUSA_NO_CHAO := 0.35
const PULOS_NO_TERRENO := 3
const DISTANCIA_PULO := 48.0
const ESCALA_INICIAL := 0.55
const ESCALA_PICO := 1.35

var estado := Estado.NO_CHAO
var pulos_em_terra := 0
var pausa_restante := 0.0

@onready var corpo: ColorRect = $Corpo
@onready var agente: NavigationAgent2D = $NavigationAgent2D


func _ready() -> void:
	set_physics_process(false)


func saltar(destino: Vector2, verde: bool) -> void:
	if verde:
		corpo.color = COR_VERDE

	estado = Estado.SAINDO_DO_RIO
	_pular_ate(destino)
	set_physics_process(true)


# Navegação adaptada da Parte 1 do roteiro da Aula 10 para pulos com assistência do Codex.
func _physics_process(delta: float) -> void:
	if estado != Estado.NO_CHAO:
		return

	pausa_restante -= delta
	if pausa_restante > 0.0:
		return
	if pulos_em_terra == PULOS_NO_TERRENO:
		estado = Estado.ENCERRADO
		queue_free()
		return

	var jogador := get_tree().get_first_node_in_group("player") as Node2D
	if jogador == null or NavigationServer2D.map_get_iteration_id(agente.get_navigation_map()) == 0:
		return

	agente.target_position = jogador.global_position
	var proximo := agente.get_next_path_position()
	if agente.get_current_navigation_path().is_empty():
		return

	var origem := global_position
	var passo := origem.move_toward(proximo, DISTANCIA_PULO) - origem
	# A verificação com move_and_collide() em modo de teste segue a documentação da Godot.
	var colisao := move_and_collide(passo, true)
	if colisao != null:
		passo = colisao.get_travel()
		if passo.length_squared() < 0.01:
			return

	pulos_em_terra += 1
	estado = Estado.PULANDO_EM_TERRA
	_pular_ate(origem + passo)


# Abate em um golpe adaptado do roteiro da Aula 10, Parte 2.
func levar_golpe() -> void:
	if estado != Estado.NO_CHAO:
		return

	estado = Estado.ENCERRADO
	get_tree().current_scene.inimigo_morreu()
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
	pausa_restante = PAUSA_NO_CHAO
	estado = Estado.NO_CHAO


func _animar_salto(progresso: float, origem: Vector2, destino: Vector2) -> void:
	global_position = origem.lerp(destino, progresso)
	var escala: float
	if progresso < 0.5:
		escala = lerpf(ESCALA_INICIAL, ESCALA_PICO, progresso * 2.0)
	else:
		escala = lerpf(ESCALA_PICO, 1.0, progresso * 2.0 - 1.0)
	corpo.scale = Vector2.ONE * escala
