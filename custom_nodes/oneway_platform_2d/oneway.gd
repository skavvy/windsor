@tool
@icon("res://addons/at-icons/node2d/arrow_up_to_line.svg")
extends StaticBody2D
class_name OnewayPlatform2D

var collision_shape: CollisionShape2D
var sprite: Sprite2D

@export_range(-360, 360, 45, "or_greater", "or_less", "prefer_slider", "degrees") var direction: float
@export_range(0, 100, 0.1, "or_greater", "prefer_slider") var length: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#region Collision
	collision_shape = CollisionShape2D.new()
	collision_shape.one_way_collision = true
	collision_shape.one_way_collision_direction = Vector2.from_angle(direction)
	
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = Vector2(8, 16)
	
	add_child(collision_shape)
	#endregion
	
	#region Sprite
	sprite = Sprite2D.new()
	sprite.scale = Vector2(1, 4)
	
	sprite.texture = preload("res://assets/oneway.png")
	
	add_child(sprite)
	#endregion


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	z_index = -1
	collision_shape.one_way_collision_direction = Vector2.from_angle(deg_to_rad(direction))
	
	collision_shape.shape.size = Vector2(8 * length, 16)
	sprite.scale = Vector2(length, 4)
	
	scale = Vector2(1, 1)
