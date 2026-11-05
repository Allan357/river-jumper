extends CharacterBody2D

var speed = 160
var vida := 3
var invencivel := false
var pode_atacar := true

@onready var hurtbox: Area2D = $Hurtbox
@onready var ataque: Area2D = $Ataque
@onready var golpe: ColorRect = $Ataque/Golpe


# Movimento adaptado do exemplo “8-way movement” da documentação oficial da Godot.
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed


func _physics_process(_delta):
	get_input()
	move_and_slide()


# Dano e invencibilidade adaptados do roteiro prático da Aula 09, Parte 3.
func _process(_delta: float) -> void:
	if vida > 0 and not invencivel and hurtbox.has_overlapping_bodies():
		levar_dano()
	if vida > 0 and pode_atacar and Input.is_action_just_pressed("atacar"):
		atacar()


func levar_dano() -> void:
	vida -= 1
	if vida <= 0:
		get_tree().current_scene.perder()
		return

	invencivel = true
	modulate.a = 0.4
	await get_tree().create_timer(1.0).timeout
	modulate.a = 1.0
	invencivel = false


# Ataque em área e recarga adaptados do roteiro prático da Aula 10, Parte 2.
func atacar() -> void:
	pode_atacar = false
	for inimigo in ataque.get_overlapping_bodies():
		inimigo.levar_golpe()

	golpe.show()
	await get_tree().create_timer(0.1).timeout
	golpe.hide()
	await get_tree().create_timer(0.3).timeout
	pode_atacar = true
