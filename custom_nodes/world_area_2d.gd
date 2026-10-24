@tool
extends VisibleOnScreenEnabler2D
class_name WorldArea2D

@export var ambience: Ambience
var area: Area2D
var collision: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area = Area2D.new()
	collision = CollisionShape2D.new()
	collision.shape = RectangleShape2D.new()
	
	area.add_child(collision)
	add_child(area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	collision.hide()
	area.position = (rect.position + rect.end) / 2
	collision.shape.size = rect.size
	enable_node_path = get_path()
	if ambience:
		for thing in area.get_overlapping_areas():
			if thing.has_method("set_ambience"):
				thing.set_ambience(ambience)
