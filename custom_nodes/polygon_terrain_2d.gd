@tool
extends Polygon2D
class_name PolygonTerrain2D

@export var show_collision: bool = true
@export_enum("Caves", "Fields", "Snowday") var style = "Caves"

var outline_color: Color
var inline: Line2D
var static_body: StaticBody2D
var collision_polygon: CollisionPolygon2D

func _init() -> void:
	static_body = StaticBody2D.new()
	collision_polygon = CollisionPolygon2D.new()
	inline = Line2D.new()
	
	static_body.collision_layer = 1
	inline.width = 40
	inline.z_index = 0
	inline.texture = load("res://assets/terrain/cave_terrain_outline.png")
	inline.texture_mode = Line2D.LINE_TEXTURE_TILE
	inline.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	inline.closed = true
	
	static_body.add_child(collision_polygon)
	add_child(static_body)
	add_child(inline)
	
	collision_polygon.polygon = polygon
	uv = polygon
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW

func _process(delta: float) -> void:
	queue_redraw()
	inline.points = polygon
	texture_scale = Vector2(0.25, 0.25)
	color = Color.WHITE
	
	if style == "Caves":
		texture = preload("res://assets/terrain/cave_terrain_fill.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("cf752b")
	
	if show_collision:
		collision_polygon.show()
	else:
		collision_polygon.hide()
	
	collision_polygon.polygon = polygon
	uv = polygon

func _draw() -> void:
	if polygon.size() > 2:
		var lines = polygon
		lines.append_array(PackedVector2Array([polygon.get(0)]))
		draw_polyline(lines, outline_color, 5)
