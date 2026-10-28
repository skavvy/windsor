@tool
extends Polygon2D
class_name PolygonTerrain2D

@export var show_collision: bool = true
@export_enum("Caves", "Fields", "Ruins") var style: String = "Caves"

var inline: Line2D
var static_body: StaticBody2D
var collision_polygon: CollisionPolygon2D
var outline_color: Color
var lines: PackedVector2Array

func _ready() -> void:
	static_body = StaticBody2D.new()
	collision_polygon = CollisionPolygon2D.new()
	inline = Line2D.new()
	
	static_body.collision_layer = 1
	inline.width = 40
	inline.z_index = 0
	inline.texture_mode = Line2D.LINE_TEXTURE_TILE
	inline.texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	inline.closed = true
	
	static_body.add_child(collision_polygon)
	add_child(static_body)
	add_child(inline)
	
	collision_polygon.polygon = polygon
	uv = polygon
	clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	if style == "Caves":
		texture = preload("res://assets/terrain/cave_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/cave_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("f0b541")
	elif style == "Fields":
		texture = preload("res://assets/terrain/fields_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/fields_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("c8d45d")
	elif style == "Ruins":
		texture = preload("res://assets/terrain/ruins_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/ruins_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("ff5277")

func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		inline.points = polygon
		return
	
	collision_polygon.polygon = polygon
	
	if style == "Caves":
		texture = preload("res://assets/terrain/cave_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/cave_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("f0b541")
	elif style == "Fields":
		texture = preload("res://assets/terrain/fields_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/fields_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("c8d45d")
	elif style == "Ruins":
		texture = preload("res://assets/terrain/ruins_terrain_fill.png")
		inline.texture = preload("res://assets/terrain/ruins_terrain_outline.png")
		texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
		outline_color = Color("ff5277")
	
	if show_collision:
		collision_polygon.show()
	else:
		collision_polygon.hide()
	queue_redraw()

func _draw() -> void:
	lines = polygon
	lines.append_array([polygon[0]])
	draw_polyline(lines, outline_color, 2)
