@icon("uid://uwrtqboyla0v")
extends Node2D
class_name WindsorSpawnPoint2D

@export var phantom_camera: PhantomCamera2D
@export var real_camera: Camera2D
@export var enabled: bool = true
@export var default_flutters: int = 0
@export var orbs: Node2D
var player: WindsorPlayer2D
var attached_debugger: WindsorDebugger

var cpu_particles: CPUParticles2D

var save_data: WindsorSaveData = WindsorSaveData.new()
var save_file: FileAccess
var can_pause: bool = true

var player_area: Area2D

func respawn() -> void:
	if enabled:
		can_pause = false
		player.disconnect("dead", respawn)
		player.queue_free()
		
		#region Death Particles
		cpu_particles = CPUParticles2D.new()
		cpu_particles.position = player.position
	
		cpu_particles.amount = 16
		cpu_particles.emitting = false

		cpu_particles.one_shot = true
		cpu_particles.explosiveness = 0.8

		cpu_particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
		cpu_particles.emission_sphere_radius = 16

		cpu_particles.direction = -player.velocity
		cpu_particles.spread = 10

		cpu_particles.gravity = Vector2(0, 0)

		cpu_particles.initial_velocity_min = player.velocity.length() / 2
		cpu_particles.initial_velocity_max = player.velocity.length() / 2

		cpu_particles.scale_amount_min = 4.0
		cpu_particles.scale_amount_max = 4.0

		cpu_particles.color_ramp = Gradient.new()
		cpu_particles.color_ramp.offsets = PackedFloat32Array([0.6, 1.0])
		cpu_particles.color_ramp.colors = PackedColorArray([Color(0xffffffff), Color(0xffffff00)])
		#endregion
		
		add_child(cpu_particles)
		
		cpu_particles.emitting = true
		
		await get_tree().create_timer(0.5).timeout
		
		player = preload("res://custom_nodes/windsor_player_2d.scn").instantiate()
		add_child(player)

		player.spawn_position = global_position
		player.global_position = global_position
		player.max_flutters = default_flutters
		
		if FileAccess.file_exists("user://windsor.save"):
			load_game()

		player.connect("dead", respawn)
		
		phantom_camera.follow_target = player
		
		can_pause = true

func _ready() -> void:
	if not enabled:
		queue_free()
		return
	
	can_pause = false
	player = preload("res://custom_nodes/windsor_player_2d.scn").instantiate()
	add_child(player)

	player.spawn_position = global_position
	if FileAccess.file_exists("user://windsor.save"):
		if FileAccess.get_file_as_string("user://windsor.save").is_empty():
			player.global_position = global_position
			player.max_flutters = default_flutters
		else:
			load_game()
	else:
		player.global_position = global_position
		player.max_flutters = default_flutters
	

	player.connect("dead", respawn)
	
	phantom_camera.follow_target = player
	can_pause = true

func save_game() -> void:
	if player:
		save_file = FileAccess.open("user://windsor.save", FileAccess.WRITE)
	
		save_data.safe_position = player.last_safe_position
		save_data.flutters = player.max_flutters
		save_data.unlocked_orbs = player.used_orbs
	
		save_file.store_line(save_data.serialize())
		save_file.flush()
		save_file.close()

func autosave_game() -> void:
	if player:
		save_file = FileAccess.open("user://windsor.save", FileAccess.WRITE)
		save_data.safe_position = player.last_safe_position
		save_data.flutters = player.max_flutters
		save_data.unlocked_orbs = player.used_orbs
		
		save_file = FileAccess.open("user://windsor.save", FileAccess.WRITE)
		save_file.store_line(save_data.serialize())
		save_file.flush()
		save_file.close()
		
		save_file = FileAccess.open("user://windsor.save", FileAccess.READ)
		print(save_file.get_as_text())
		save_file.close()

func load_game() -> void:
	real_camera.position = player.position
	phantom_camera.position = player.position
	
	save_file = FileAccess.open("user://windsor.save", FileAccess.READ)
	var save_string = save_file.get_as_text()
	
	if attached_debugger:
		save_data = attached_debugger.savefile
		save_string = attached_debugger.savefile.serialize()
		print(save_data.serialize())
	else:
		save_string = save_file.get_as_text()
		save_data.deserialize(save_string) 
		
	if not save_string.is_empty():
		player.position = save_data.safe_position
		player.max_flutters = save_data.flutters
		
		var used_orbs: Array = save_data.unlocked_orbs
		player.used_orbs = used_orbs
		
		for orb in orbs.get_children():
			if save_data.unlocked_orbs.has(orb.id):
				orb.used = true
				orb.render_sprite = false

var pause_screen = "res://pause_screen.scn"

func _process(delta: float) -> void:
	if enabled:
		autosave_game()
		if Input.is_action_just_pressed("game_pause") and can_pause:
			save_game()
			get_tree().change_scene_to_file(pause_screen)
