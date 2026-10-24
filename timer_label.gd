extends Label
var transform_checker: Vector2
var tick: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = Time.get_time_string_from_unix_time(tick)
	if transform_checker != get_viewport_transform().get_origin():
		position = get_viewport_transform().get_origin() / get_viewport_rect().size \
			- get_viewport_rect().size / 2 + Vector2(0, -40)
	transform_checker = get_viewport_transform().get_origin()

func _on_timer_timeout() -> void:
	tick += 1
