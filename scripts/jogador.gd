extends CharacterBody2D

var speed = 160
var vida := 3
var invencivel := false

@onready var hurtbox: Area2D = $Hurtbox


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
