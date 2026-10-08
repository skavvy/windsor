@tool
extends VisibleOnScreenEnabler2D
class_name GameScreen2D

@export_multiline("Screen description and notes") var description: String
@export var title: String
@export var debug: bool = false

var tracking_point = Node2D.new()
var tracking_area = Area2D.new()
var collision_shape = CollisionShape2D.new()

func _process(delta: float) -> void:
	enable_node_path = self.get_path()
	show_rect = debug
	rect = Rect2(0, 0, 1152, 648)

func _init() -> void:
	if not Engine.is_editor_hint():
		add_child(tracking_point)
		tracking_area.add_child(collision_shape)
		add_child(tracking_area)
	
		collision_shape.shape = RectangleShape2D.new()
		assert(collision_shape.shape is RectangleShape2D)
	
		collision_shape.shape.size = Vector2(1152, 648)
		collision_shape.position = Vector2(1152 / 2, 648 / 2)
	
		tracking_point.global_position = tracking_area.global_position
	else:
		rect = Rect2(0, 0, 1152, 648)
		pass
