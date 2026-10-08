@tool
@icon("uid://1yipspqlrh1c")
extends Area2D
class_name BounceOrb2D

@export_range(-360, 360, 0.1, "or_greater", "or_less", "prefer_slider", "degrees") var angle: float = 0
var direction: Vector2
@export_range(0, 1000, 50, "or_greater", "prefer_slider") var speed

var handle: Node2D
var timeout: SceneTreeTimer

var collision_shape: CollisionShape2D
var cpu_particles: CPUParticles2D
var drawing_child: Node2D
var disabled: bool = false

func _draw() -> void:
	if not disabled:
		draw_texture_rect(preload("res://assets/bounce_orb_enabled.png"), Rect2(-20, -20, 40, 40),
			false)
	else:
		draw_texture_rect(preload("res://assets/bounce_orb_disabled.png"), Rect2(-20, -20, 40, 40),
			false)
	drawing_child.rotation_degrees = angle

func _child_draw() -> void:
	var direction = Vector2.from_angle(deg_to_rad(rotation_degrees)).normalized()
	var arrow: PackedVector2Array = PackedVector2Array([
		direction * 75, (direction * 75) + Vector2(-15, 15).rotated(direction.angle()),
		direction * 75, (direction * 75) + Vector2(-15, -15).rotated(direction.angle())
	])
	if not disabled:
		drawing_child.draw_multiline(arrow, Color("ff5277"))
	else:
		drawing_child.draw_multiline(arrow, Color("b42c75"))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drawing_child = Node2D.new()
	
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
	
	cpu_particles.initial_velocity_min = speed / 2
	cpu_particles.initial_velocity_max = speed / 2
	
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
	
	add_child(collision_shape)
	add_child(cpu_particles)
	add_child(drawing_child)
	drawing_child.connect("draw", _child_draw)

func wait_for_cooldown() -> void:
	disabled = false
	queue_redraw()
	drawing_child.queue_redraw()

func _process(delta: float) -> void:
	drawing_child.rotation_degrees = angle
	drawing_child.queue_redraw()
	direction = Vector2.from_angle(deg_to_rad(angle))
	direction = direction.normalized()
	cpu_particles.direction = direction
	if Engine.is_editor_hint():
		cpu_particles.direction = direction
	for area in get_overlapping_areas():
		if area.has_method("boost") and not disabled:
			area.boost(direction * speed)
			cpu_particles.emitting = true
			disabled = true
			queue_redraw()
			drawing_child.queue_redraw()
			timeout = get_tree().create_timer(2)
			timeout.connect("timeout", wait_for_cooldown)
