@warning_ignore("missing_tool")
extends WorldArea2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	collision.hide()
	area.position = (rect.position + rect.end) / 2
	collision.shape.size = rect.size
	enable_node_path = get_path()
	for thing in area.get_overlapping_areas():
		if thing.has_method("set_ambience"):
			thing.set_ambience(ambience)
	if not area.area_exited.is_connected(area_exited):
		area.area_exited.connect(area_exited)

func area_exited(exiting_area: Area2D):
	if exiting_area.has_method("reset_to"):
		exiting_area.reset_to(2)
