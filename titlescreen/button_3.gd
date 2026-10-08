extends TextureButton

func _pressed() -> void:
	get_tree().quit(0)

func _process(delta: float) -> void:
	if has_focus():
		position.x += 1 + position.x / 2
		if position.x > 10:
			position.x = 10
	else:
		position.x -= 1 + position.x / 2
		if position.x < 0:
			position.x = 0
