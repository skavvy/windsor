@tool
extends Sprite2D
class_name AmbienceManager2D

@export_group("Sky")
@export_subgroup("Clouds")
@export var cloud_speed: float
@export var cloud_color: Color = Color("323232")
@export_subgroup("Sky")
@export var upper_sky_color: Color = Color("3c4a57")
@export var lower_sky_color: Color = Color("b9dcfb")
@export_subgroup("Effects")
@export var lightning: bool = false
var lightning_cooldown: Timer
var lightning_decider: RandomNumberGenerator

func _ready() -> void:
	z_index = -10
	texture = PlaceholderTexture2D.new()
	lightning_decider = RandomNumberGenerator.new()
	
	lightning_cooldown = Timer.new()
	add_child(lightning_cooldown)
	lightning_cooldown.connect("timeout", flash)
	
	material = ShaderMaterial.new()
	material.shader = preload("res://shaders/sky.gdshader")
	material.set_shader_parameter("wind_speed", cloud_speed)
	material.set_shader_parameter("down_color", upper_sky_color)
	material.set_shader_parameter("up_color", lower_sky_color)
	material.set_shader_parameter("cloud_color", cloud_color)
	
	flash()

func flash() -> void:
	material.set_shader_parameter("down_color", Color("ddd"))
	material.set_shader_parameter("up_color", Color("fff"))
	material.set_shader_parameter("cloud_color", Color("ddd"))
	
	await get_tree().create_timer(0.05).timeout
	
	material.set_shader_parameter("down_color", Color("3c4a57"))
	material.set_shader_parameter("up_color", Color("b9dcfb"))
	material.set_shader_parameter("cloud_color", Color("323232"))
	
	await get_tree().create_timer(0.1).timeout
	
	material.set_shader_parameter("down_color", Color("ddd"))
	material.set_shader_parameter("up_color", Color("fff"))
	material.set_shader_parameter("cloud_color", Color("ddd"))
	
	await get_tree().create_timer(0.05).timeout
	
	material.set_shader_parameter("down_color", Color("3c4a57"))
	material.set_shader_parameter("up_color", Color("b9dcfb"))
	material.set_shader_parameter("cloud_color", Color("323232"))
	
	lightning_cooldown.wait_time = lightning_decider.randf_range(4, 8)
	lightning_decider.randomize()
	lightning_cooldown.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	material.set_shader_parameter("wind_speed", cloud_speed)
	material.set_shader_parameter("down_color", upper_sky_color)
	material.set_shader_parameter("up_color", lower_sky_color)
	material.set_shader_parameter("cloud_color", cloud_color)
