@tool
@icon("uid://1yipspqlrh1c")
extends Area2D
class_name UpgradeOrb2D

@export var amount: int = 2
@export var id: int = 0
var collision_shape: CollisionShape2D
var cpu_particles: CPUParticles2D
var sound_player: AudioStreamPlayer2D
var used: bool = false
var render_sprite: bool = true

func _draw() -> void:
	if render_sprite:
		draw_texture_rect(preload("res://assets/upgrade_orb_enabled.png"),
			Rect2(-20, -20, 40, 40),
			false)
	else:
		draw_texture_rect(preload("res://assets/upgrade_orb_disabled.png"),
			Rect2(-20, -20, 40, 40),
			false)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_index = -2
	material = ShaderMaterial.new()
	material.shader = preload("res://shaders/wave.gdshader")
	#region Collision Shape
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
	
	cpu_particles.direction = Vector2(0, 0)
	cpu_particles.spread = 10
	
	cpu_particles.gravity = Vector2(0, 0)
	
	cpu_particles.initial_velocity_min = 30.0
	cpu_particles.initial_velocity_max = 30.0
	
	cpu_particles.scale_amount_min = 4
	cpu_particles.scale_amount_max = 4
	cpu_particles.split_scale = true
	cpu_particles.scale_curve_x = preload("res://custom_nodes/upgrade_orb_2d/scale_curve_x.res")
	cpu_particles.scale_curve_y = preload("res://custom_nodes/upgrade_orb_2d/scale_curve_y.res")
	
	cpu_particles.color_ramp = Gradient.new()
	cpu_particles.color_ramp.offsets = PackedFloat32Array([0.6, 1.0])
	cpu_particles.color_ramp.colors = PackedColorArray([Color(0x92e8c0ff), Color(0x92e8c000)])
	#endregion
	
	#region Sound
	sound_player = AudioStreamPlayer2D.new()
	add_child(sound_player)
	sound_player.playing = false
	sound_player.autoplay = false
	sound_player.stream = preload("res://assets/audio/upgrade_hit.ogg")
	#endregion
	
	add_child(collision_shape)
	add_child(cpu_particles)
	
	cpu_particles.global_position = global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not Engine.is_editor_hint():
		if used:
			render_sprite = false
		for area in get_overlapping_areas():
			if area.has_method("upgrade"):
				if not used:
					used = true
					
					area.upgrade(amount, id)
					var slowdown = Slowdown.new()
					slowdown.amount = 1 / amount
					slowdown.speed = 0.025
					get_parent().add_child(slowdown)
				
					cpu_particles.emitting = true
					sound_player.playing = true
					cpu_particles.direction = area.get_parent().velocity.normalized()
					cpu_particles.initial_velocity_min = area.get_parent().velocity.length()
				
					render_sprite = false
					queue_redraw()
				
					await cpu_particles.finished
					await sound_player.finished
					sound_player.playing = false
				else:
					await cpu_particles.finished
					await sound_player.finished
					sound_player.playing = false
