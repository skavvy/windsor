@tool
@icon("uid://1yipspqlrh1c")
extends Area2D
class_name BoostOrb2D

var direction: Vector2
@export_range(0, 1000, 50, "or_greater", "prefer_slider") var speed: int

var handle: Node2D
var timeout: SceneTreeTimer

var collision_shape: CollisionShape2D
var cpu_particles: CPUParticles2D
var sound_player: AudioStreamPlayer2D
var disabled: bool = false

func _draw() -> void:
	if not disabled:
		draw_texture_rect(preload("res://assets/boost_orb_enabled.png"), Rect2(-20, -20, 40, 40),
			false)
	else:
		draw_texture_rect(preload("res://assets/boost_orb_disabled.png"), Rect2(-20, -20, 40, 40),
			false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = -2
	material = ShaderMaterial.new()
	material.shader = preload("res://shaders/wave.gdshader")
	
	#region Collision
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = CircleShape2D.new()
	collision_shape.shape.radius = 16
	#endregion
	
	#region Particles
	cpu_particles = CPUParticles2D.new()
	
	cpu_particles.amount = 16
	cpu_particles.emitting = false
	
	cpu_particles.one_shot = true
	cpu_particles.explosiveness = 0.8
	
	cpu_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
	cpu_particles.emission_sphere_radius = 16
	
	cpu_particles.direction = direction
	cpu_particles.spread = 10
	
	cpu_particles.gravity = Vector2(0, 0)
	
	cpu_particles.initial_velocity_min = speed / 2.0
	cpu_particles.initial_velocity_max = speed / 2.0
	
	cpu_particles.scale_amount_min = 4.0
	cpu_particles.scale_amount_max = 4.0
	cpu_particles.split_scale = true
	cpu_particles.scale_curve_x = preload("res://custom_nodes/bounce_orb_2d/scale_curve_x.res")
	cpu_particles.scale_curve_y = preload("res://custom_nodes/bounce_orb_2d/scale_curve_y.res")
	
	cpu_particles.color_ramp = Gradient.new()
	cpu_particles.color_ramp.offsets = PackedFloat32Array([0.5, 1.0])
	cpu_particles.color_ramp.colors = PackedColorArray([Color(0xff5277ff), Color(0xb42c7500)])
	
	cpu_particles.process_mode = Node.PROCESS_MODE_ALWAYS
	#endregion
	
	#region Sound
	sound_player = AudioStreamPlayer2D.new()
	add_child(sound_player)
	sound_player.playing = false
	sound_player.autoplay = false
	sound_player.stream = preload("res://assets/audio/boost_hit.ogg")
	#endregion
	
	add_child(collision_shape)
	add_child(cpu_particles)

func wait_for_cooldown() -> void:
	disabled = false
	queue_redraw()

func _process(_delta: float) -> void:
	for area: Area2D in get_overlapping_areas():
		if area.has_method("boost") and not disabled:
			direction = area.get_parent().velocity.normalized()
			cpu_particles.direction = direction
			area.boost(direction * speed)
			cpu_particles.emitting = true
			sound_player.playing = true
			disabled = true
			queue_redraw()
			timeout = get_tree().create_timer(2)
			var err: Error = timeout.connect("timeout", wait_for_cooldown)
			print(err)
