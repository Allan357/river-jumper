extends Node2D

const CENA_INIMIGO := preload("res://entities/inimigo.tscn")
const TOTAL_ALIADOS := 5
const LIMITE_ICONES_ABATES := 5
const COR_CORACAO_VAZIO := Color(0.58, 0.65, 0.66, 0.48)
const ESPACO_NA_FILA := 24.0
const LIMITE_DO_RASTRO := 96

var partida_encerrando := false
var partida_perdida := false
var fila: Array[Node2D] = []
var rastro := PackedVector2Array()
var vermelhos_lancados := 0
var abates := 0

@onready var jogador := $Jogador
@onready var agua: CollisionShape2D = $Navegacao/Agua/Colisao1
@onready var muro_esquerdo: CollisionShape2D = $Navegacao/Muros/Esquerdo/Colisao
@onready var area_terreno: Rect2 = _calcular_area_terreno()
@onready var origem_saltos: Marker2D = $OrigemSaltos
@onready var horda: Timer = $Horda
@onready var coracoes: HBoxContainer = $HUD/Status/Vida
@onready var icones_abates: HBoxContainer = $HUD/Status/Abates/Icones
@onready var excesso_abates: Label = $HUD/Status/Abates/Excesso


# Posições iniciais sorteadas com o Codex usando a consulta intersect_shape() da Godot.
func _ready() -> void:
	_atualizar_vida(jogador.vida)
	await get_tree().physics_frame
	var espaco := get_world_2d().direct_space_state
	var folga := CircleShape2D.new()
	folga.radius = 30.0
	var consulta := PhysicsShapeQueryParameters2D.new()
	consulta.shape = folga
	consulta.collision_mask = 1

	var aliados := $Aliados.get_children()
	var area := area_terreno.grow(-folga.radius)
	var sorteados: Array[Vector2] = []
	for _tentativa in range(256):
		var ponto := Vector2(randf_range(area.position.x, area.end.x),
			randf_range(area.position.y, area.end.y))
		if ponto.distance_squared_to(jogador.global_position) < 96.0 * 96.0:
			continue
		if sorteados.any(func(outro: Vector2) -> bool: return ponto.distance_squared_to(outro) < 104.0 * 104.0):
			continue
		consulta.transform = Transform2D(0.0, ponto)
		if espaco.intersect_shape(consulta, 1).is_empty():
			sorteados.append(ponto)
			if sorteados.size() == aliados.size():
				for i in range(aliados.size()):
					aliados[i].global_position = sorteados[i]
				return


# HUD de vida adaptado do roteiro da Aula 09 com ícones e sinal de dano integrados pelo Codex.
func _atualizar_vida(vidas: int) -> void:
	for i in range(coracoes.get_child_count()):
		var coracao := coracoes.get_child(i) as TextureRect
		coracao.self_modulate = Color.WHITE if i < vidas else COR_CORACAO_VAZIO


# Fila de resgate adaptada da ficha da Aula 10; rastro implementado com o Codex.
func _physics_process(_delta: float) -> void:
	if partida_encerrando:
		return
	var ponto: Vector2 = jogador.global_position
	if rastro.is_empty() or rastro[-1].distance_squared_to(ponto) >= 4.0:
		rastro.append(ponto)
		if rastro.size() > LIMITE_DO_RASTRO:
			rastro.remove_at(0)


func resgatar(aliado: Node2D) -> void:
	if partida_encerrando or aliado.indice_fila >= 0:
		return

	aliado.indice_fila = fila.size()
	fila.append(aliado)
	if fila.size() == TOTAL_ALIADOS:
		vencer()


func ponto_da_fila(indice: int) -> Vector2:
	var anterior: Vector2 = jogador.global_position
	var restante := ESPACO_NA_FILA * (indice + 1)
	for i in range(rastro.size() - 1, -1, -1):
		var ponto := rastro[i]
		var trecho := anterior.distance_to(ponto)
		if trecho >= restante:
			return anterior.move_toward(ponto, restante)
		restante -= trecho
		anterior = ponto
	return anterior


# Contagem de abates adaptada do roteiro prático da Aula 10, Parte 2.
func inimigo_morreu(posicao: Vector2, textura: Texture2D) -> void:
	abates += 1
	_adicionar_icone_abate(textura)
	_mostrar_abate(posicao)


# Ícones dos abates implementados com o Codex usando TextureRect da Godot.
func _adicionar_icone_abate(textura: Texture2D) -> void:
	if abates > LIMITE_ICONES_ABATES:
		excesso_abates.text = "+%d" % (abates - LIMITE_ICONES_ABATES)
		excesso_abates.show()
		return

	var icone := TextureRect.new()
	icone.texture = textura
	icone.custom_minimum_size = Vector2(24, 24)
	icone.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icone.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icone.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	icones_abates.add_child(icone)


# Feedback de abate implementado com o Codex usando Label e Tween da Godot.
func _mostrar_abate(posicao: Vector2) -> void:
	var aviso := Label.new()
	aviso.text = "+1"
	aviso.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	aviso.size = Vector2(30, 24)
	aviso.position = to_local(posicao) - Vector2(15, 16)
	aviso.mouse_filter = Control.MOUSE_FILTER_IGNORE
	aviso.z_index = 4
	aviso.add_theme_font_size_override("font_size", 19)
	aviso.add_theme_color_override("font_color", Color(1.0, 0.9, 0.6))
	aviso.add_theme_color_override("font_outline_color", Color(0.10, 0.16, 0.15))
	aviso.add_theme_constant_override("outline_size", 4)
	add_child(aviso)

	var efeito := aviso.create_tween().set_parallel()
	efeito.tween_property(aviso, "position:y", aviso.position.y - 14.0, 0.28)
	efeito.tween_property(aviso, "modulate:a", 0.0, 0.18).set_delay(0.1)
	efeito.chain().tween_callback(aviso.queue_free)


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


func _calcular_area_terreno() -> Rect2:
	var tamanho_agua := (agua.shape as RectangleShape2D).size
	var centro_do_muro := muro_esquerdo.global_position.x
	var metade_do_muro := (muro_esquerdo.shape as RectangleShape2D).size.x / 2.0
	var esquerda := centro_do_muro + metade_do_muro
	var inicio_da_agua := agua.global_position - tamanho_agua / 2.0
	return Rect2(esquerda, inicio_da_agua.y, inicio_da_agua.x - esquerda, tamanho_agua.y)


# Sorteio implementado com o Codex usando intersect_shape(), da documentação oficial da Godot.
func _sortear_pouso(forma: RectangleShape2D, mascara: int) -> Vector2:
	var folga := maxf(forma.size.x, forma.size.y) / 2.0 + 1.0
	var area := area_terreno.grow(-folga)
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
	partida_perdida = true
	_agendar_fim()


func _agendar_fim() -> void:
	if partida_encerrando:
		return

	partida_encerrando = true
	horda.stop()
	_encerrar.call_deferred()


func _encerrar() -> void:
	if partida_perdida or jogador.vida <= 0:
		get_tree().change_scene_to_file("res://scenes/derrota.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/vitoria.tscn")
