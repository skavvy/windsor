@icon("uid://uwrtqboyla0v")
extends Node2D
class_name WindsorSpawnPoint2D

@export var ambience_manager: AmbienceManager2D
@export var phantom_camera: PhantomCamera2D
@export var real_camera: Camera2D
@export var enabled: bool = true
@export var default_flutters: int = 0
@export var orbs: Node2D
@export var timer_label: Label
var savefile: WindsorSaveData
var player: WindsorPlayer2D
var attached_debugger: WindsorDebugger
var start_tick:	int = 0

var cpu_particles: CPUParticles2D

var can_pause: bool = true
var timer_stop: bool = false
var can_save: bool = true

var player_area: Area2D

func respawn() -> void:
	if enabled:
		can_save = false
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
		player.connect("dead", respawn)
		
		phantom_camera.follow_target = player
		
		can_pause = true
		
		phantom_camera.teleport_position()
		
		file_load()
		can_save = true

func _ready() -> void:
	if not enabled:
		queue_free()
		return
	
	can_save = false
	can_pause = false
	player = preload("res://custom_nodes/windsor_player_2d.scn").instantiate()
	add_child(player)

	player.connect("dead", respawn)
	
	phantom_camera.follow_target = player
	can_pause = true
	
	phantom_camera.teleport_position()
	
	file_load()
	can_save = true

func set_ambience(ambience: Ambience) -> void:
	ambience_manager.ambience = ambience

func file_load() -> void:
	savefile = WindsorSaveData.new()
	if FileAccess.file_exists("user://windsor.save"):
		savefile.load_file()
		
		player.position = savefile.spos
		player.max_flutters = savefile.flut
		
		player.used_orbs = savefile.orbs
		for orb in orbs.get_children():
			if orb is UpgradeOrb2D:
				if orb.id in savefile.orbs:
					orb.used = true
					orb.render_sprite = false
				else:
					orb.used = false
					orb.render_sprite = true
		
		timer_label.tick = savefile.tick
		start_tick = Time.get_unix_time_from_system() - timer_label.tick
	else:
		savefile.reset()
		
		player.position = Vector2.ZERO
		player.max_flutters = default_flutters
		
		player.used_orbs = [-1]
		
		timer_label.tick = 0
		start_tick = Time.get_unix_time_from_system()

func file_save() -> void:
	can_save = false
	savefile.flut = player.max_flutters
	savefile.spos = player.last_safe_position
	savefile.orbs = player.used_orbs
	savefile.tick = timer_label.tick
	savefile.save_file()
	can_save = true

var pause_screen = "res://pause_screen.scn"

func _process(delta: float) -> void:
	if enabled:
		timer_label.tick = Time.get_unix_time_from_system() - start_tick
		if player and can_save:
			file_save()
		if Input.is_action_just_pressed("game_pause") and can_pause:
			get_tree().change_scene_to_file(pause_screen)
		if Input.is_action_just_pressed("game_reset"):
			if player:
				player.position = Vector2.ZERO
				player.max_flutters = 0
				player.flutters_midair = 0
				player.used_orbs = [-1]
				player.squash_and_stretch = 0
				player.velocity = Vector2.ZERO
				phantom_camera.teleport_position()
				timer_label.tick = 0
				start_tick = Time.get_unix_time_from_system()
				savefile.reset()
				savefile.save_file()
				savefile.load_file()
			else:
				timer_label.tick = 0
				start_tick = Time.get_unix_time_from_system()
				savefile.reset()
				savefile.save_file()
				savefile.load_file()
			for orb in orbs.get_children():
				if orb is UpgradeOrb2D:
					orb.used = false
					orb.render_sprite = true
					orb.queue_redraw()
