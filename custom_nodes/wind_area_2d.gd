@tool
extends Area2D
class_name WindArea2D

@export_range(-360, 360, 0.1, "or_greater", "or_less", "prefer_slider", "degrees") var angle: float = 0
@export_range(0, 10, 0.1, "or_greater", "prefer_slider") var speed: float = 5
@export var show_collision = true
@export var size = Vector2i(10, 10)
var direction: Vector2

var cpu_particles: CPUParticles2D
var collision_shape: CollisionShape2D

func _ready() -> void:
	cpu_particles = CPUParticles2D.new()
	cpu_particles.amount = 64
	cpu_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	cpu_particles.emission_rect_extents = size / 2
	cpu_particles.position = size / 2
	cpu_particles.spread = 10
	cpu_particles.scale_amount_min = 8
	cpu_particles.scale_amount_max = 8
	cpu_particles.z_index = -5
	cpu_particles.split_scale = true
	cpu_particles.scale_curve_x = Curve.new()
	cpu_particles.scale_curve_y = Curve.new()
	cpu_particles.scale_curve_x.add_point(Vector2(0, 0.5))
	cpu_particles.scale_curve_x.add_point(Vector2(1, 0.5))
	cpu_particles.scale_curve_y.add_point(Vector2(0, 2))
	cpu_particles.scale_curve_y.add_point(Vector2(1, 2))
	cpu_particles.particle_flag_align_y = true
	
	collision_shape = CollisionShape2D.new()
	collision_shape.shape = RectangleShape2D.new()
	collision_shape.shape.size = size
	collision_shape.position = size / 2
	
	add_child(collision_shape)
	add_child(cpu_particles)

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_line(Vector2.ZERO, direction * 50, Color.ORANGE_RED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	cpu_particles.process_mode = Node.PROCESS_MODE_ALWAYS
	if show_collision:
		collision_shape.show()
	else:
		collision_shape.hide()
	size.x = round(size.x)
	size.y = round(size.y)
	collision_shape.shape.size = size
	collision_shape.position = size / 2
	cpu_particles.emission_rect_extents = size / 2
	cpu_particles.position = size / 2
	cpu_particles.direction = direction
	cpu_particles.initial_velocity_min = speed * 50
	cpu_particles.initial_velocity_max = speed * 50
	queue_redraw()
	direction = Vector2.from_angle(deg_to_rad(angle))
	direction = direction.normalized()
	for area in get_overlapping_areas():
		if area.has_method("apply_velocity"):
			area.apply_velocity(direction * speed)
