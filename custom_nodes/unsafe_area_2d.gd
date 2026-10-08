@tool
extends Polygon2D
class_name UnsafeArea2D

var area: Area2D
var collision_polygon: CollisionPolygon2D

func _init() -> void:
	area = Area2D.new()
	collision_polygon = CollisionPolygon2D.new()
	area.add_child(collision_polygon)
	add_child(area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	color = Color.TRANSPARENT
	collision_polygon.polygon = polygon
