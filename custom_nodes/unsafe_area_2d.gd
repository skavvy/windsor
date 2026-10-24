@tool
extends Polygon2D
class_name UnsafeArea2D

var area: Area2D
var collision_polygon: CollisionPolygon2D

func _ready() -> void:
	area = Area2D.new()
	collision_polygon = CollisionPolygon2D.new()
	area.add_child(collision_polygon)
	add_child(area)
	collision_polygon.polygon = polygon

func _process(_delta: float) -> void:
	color = Color.TRANSPARENT
	area.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		return
	collision_polygon.polygon = polygon
