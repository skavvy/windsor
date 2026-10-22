extends TextureButton

func _pressed() -> void:
	get_tree().change_scene_to_file("res://layer1.scn")
	Engine.time_scale = 1

func _process(delta: float) -> void:
	if has_focus():
		position.x += 1 + position.x / 2
		if position.x > 10:
			position.x = 10
	else:
		position.x -= 1 + position.x / 2
		if position.x < 0:
			position.x = 0
