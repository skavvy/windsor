@tool
extends Sprite2D
class_name AmbienceManager2D

@export var ambience: WindsorAreaAmbience = WindsorAreaAmbience.new()
var lightning_cooldown: Timer
var lightning_decider: RandomNumberGenerator

var real_ambience: WindsorAreaAmbience = WindsorAreaAmbience.new()

func _ready() -> void:
	z_index = -10
	texture = PlaceholderTexture2D.new()
	lightning_decider = RandomNumberGenerator.new()
	
	lightning_cooldown = Timer.new()
	add_child(lightning_cooldown)
	lightning_cooldown.connect("timeout", flash)
	
	material = ShaderMaterial.new()
	material.shader = preload("res://shaders/sky.gdshader")
	material.set_shader_parameter("wind_speed", real_ambience.cloud_speed)
	material.set_shader_parameter("down_color", real_ambience.upper_sky_color)
	material.set_shader_parameter("up_color", real_ambience.lower_sky_color)
	material.set_shader_parameter("cloud_color", real_ambience.cloud_color)
	
	real_ambience = WindsorAreaAmbience.new()
	
	await flash()

func flash() -> void:
	if not real_ambience.lightning:
		pass
	else:
		material.set_shader_parameter("down_color", Color("ddd"))
		material.set_shader_parameter("up_color", Color("fff"))
		material.set_shader_parameter("cloud_color", Color("ddd"))
		
		await get_tree().create_timer(0.05).timeout
		
		material.set_shader_parameter("down_color", real_ambience.upper_sky_color)
		material.set_shader_parameter("up_color", real_ambience.lower_sky_color)
		material.set_shader_parameter("cloud_color", real_ambience.cloud_color)
		
		await get_tree().create_timer(0.1).timeout
		
		material.set_shader_parameter("down_color", Color("ddd"))
		material.set_shader_parameter("up_color", Color("fff"))
		material.set_shader_parameter("cloud_color", Color("ddd"))
		
		await get_tree().create_timer(0.05).timeout
		
		material.set_shader_parameter("down_color", real_ambience.upper_sky_color)
		material.set_shader_parameter("up_color", real_ambience.lower_sky_color)
		material.set_shader_parameter("cloud_color", real_ambience.cloud_color)
		
		lightning_cooldown.wait_time = lightning_decider.randf_range(4, 8)
		lightning_decider.randomize()
		lightning_cooldown.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	real_ambience.cloud_color.r = move_toward(real_ambience.cloud_color.r, ambience.cloud_color.r, 0.05)
	real_ambience.cloud_color.g = move_toward(real_ambience.cloud_color.g, ambience.cloud_color.g, 0.05)
	real_ambience.cloud_color.b = move_toward(real_ambience.cloud_color.b, ambience.cloud_color.b, 0.05)
	
	real_ambience.lower_sky_color.r = move_toward(real_ambience.lower_sky_color.r, ambience.lower_sky_color.r, 0.05)
	real_ambience.lower_sky_color.g = move_toward(real_ambience.lower_sky_color.g, ambience.lower_sky_color.g, 0.05)
	real_ambience.lower_sky_color.b = move_toward(real_ambience.lower_sky_color.b, ambience.lower_sky_color.b, 0.05)
	
	real_ambience.upper_sky_color.r = move_toward(real_ambience.upper_sky_color.r, ambience.upper_sky_color.r, 0.05)
	real_ambience.upper_sky_color.g = move_toward(real_ambience.upper_sky_color.g, ambience.upper_sky_color.g, 0.05)
	real_ambience.upper_sky_color.b = move_toward(real_ambience.upper_sky_color.b, ambience.upper_sky_color.b, 0.05)
	
	real_ambience.lightning = ambience.lightning
	real_ambience.cloud_speed = move_toward(real_ambience.cloud_speed, ambience.cloud_speed, 0.05)
	
	if Engine.is_editor_hint():
		scale = get_viewport_rect().size / get_viewport_transform().get_scale()
		global_position = -get_viewport_transform().get_origin() / get_viewport_transform().get_scale()
	else:
		scale = get_viewport_rect().size * 4
		position.x = -scale.x / 2
		position.y = -scale.y / 2
	
	material.set_shader_parameter("wind_speed", real_ambience.cloud_speed)
	material.set_shader_parameter("down_color", real_ambience.upper_sky_color)
	material.set_shader_parameter("up_color", real_ambience.lower_sky_color)
	material.set_shader_parameter("cloud_color", real_ambience.cloud_color)
