@tool
extends Polygon2D
class_name PolygonDeathplane2D

var area: Area2D
var collision_polygon: CollisionPolygon2D

func _init() -> void:
	self.color = Color("0000")
	area = Area2D.new()
	collision_polygon = CollisionPolygon2D.new()
	area.add_child(collision_polygon)
	add_child(area)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	collision_polygon.polygon = polygon
	for overlapping_area in area.get_overlapping_areas():
		if overlapping_area.has_method("send_signal"):
			overlapping_area.send_signal("dead")
