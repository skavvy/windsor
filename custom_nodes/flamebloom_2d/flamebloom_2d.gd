@tool
extends Node2D
class_name Flamebloom2D

@export var light_scale: float

var flamebloom_sprite: AnimatedSprite2D
var light_sprite: Sprite2D
var random_number_generator: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flamebloom_sprite = AnimatedSprite2D.new()
	light_sprite = Sprite2D.new()
	
	flamebloom_sprite.position.y = -20
	light_sprite.position.y = -20
	flamebloom_sprite.scale = Vector2(4, 4)
	
	flamebloom_sprite.z_index = -1
	light_sprite.z_index = 1
	
	add_child(flamebloom_sprite)
	add_child(light_sprite)
	
	flamebloom_sprite.sprite_frames = preload("res://custom_nodes/flamebloom_2d/flamebloom.res")
	light_sprite.texture = preload("res://assets/flamebloom_light_texture.res")
	light_sprite.scale = Vector2(4, 4)

func _draw() -> void:
	var size: float = random_number_generator.randf_range(light_scale-(light_scale / 12.5), light_scale+(light_scale / 12.5))
	light_sprite.scale = Vector2(size, size)
	
func _process(_delta: float) -> void:
	_draw()
