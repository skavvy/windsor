@tool
extends Polygon2D
class_name PolygonDeathplane2D

var area: Area2D
var collision_polygon: CollisionPolygon2D

func _ready() -> void:
	area = Area2D.new()
	collision_polygon = CollisionPolygon2D.new()
	area.add_child(collision_polygon)
	add_child(area)
	collision_polygon.polygon = polygon

func _process(_delta: float) -> void:
	area.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		for overlapping_area: Area2D in area.get_overlapping_areas():
			if overlapping_area and overlapping_area.has_method("send_signal"):
				await get_tree().create_timer(0.1).timeout
				if overlapping_area:
					overlapping_area.send_signal("dead")
		return
	collision_polygon.polygon = polygon
