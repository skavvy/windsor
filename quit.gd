extends TextureButton

func _pressed() -> void:
	var err: Error = get_tree().change_scene_to_file("res://titlescreen/titlescreen.scn")
	print(err)

func _process(_delta: float) -> void:
	if has_focus():
		position.x += 1 + position.x / 2
		if position.x > 10:
			position.x = 10
	else:
		position.x -= 1 + position.x / 2
		if position.x < 0:
			position.x = 0
