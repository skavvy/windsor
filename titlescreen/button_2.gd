extends TextureButton

func _process(_delta: float) -> void:
	if has_focus():
		position.x += 1 + position.x / 2
		if position.x > 10:
			position.x = 10
	else:
		position.x -= 1 + position.x / 2
		if position.x < 0:
			position.x = 0

func _pressed() -> void:
	var save_file: FileAccess = FileAccess.open("user://windsor.save", FileAccess.WRITE)
	if save_file.store_line(""):
		var err: Error = get_tree().change_scene_to_file("res://layer1.scn")
		if err != Error.OK:
			push_error("Scene unable to load!")
	else:
		push_error("Failed to store line to file!")
