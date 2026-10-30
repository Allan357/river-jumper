extends Control


# Reinício por Enter adaptado do roteiro prático da Aula 09, Parte 4.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/margem.tscn")
