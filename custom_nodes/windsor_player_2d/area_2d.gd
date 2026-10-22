extends Area2D
class_name PlayerInteractionArea2D

var is_green_this_frame: bool = false

func _process(_delta: float) -> void:
	is_green_this_frame = false
	if has_overlapping_areas():
		for area: Area2D in get_overlapping_areas():
			if area.get_parent().name.contains("end"):
				if not area.is_connected("area_exited", ended):
					var err: Error = area.connect("area_exited", ended)
					if err != Error.OK:
						push_error("Area exit failed to connect!")
			if area.get_parent().name.contains("Area"):
				assert(get_parent().get_parent() is WindsorSpawnPoint2D)
				var spawnpoint: WindsorSpawnPoint2D = get_parent().get_parent()
				spawnpoint.timer_stop = false

func ended(area: Area2D) -> void:
	if area == self:
		assert(get_parent().get_parent() is WindsorSpawnPoint2D)
		var spawnpoint: WindsorSpawnPoint2D = get_parent().get_parent()
		spawnpoint.timer_stop = true

func send_signal(emit: String) -> void:
	assert(get_parent() is WindsorPlayer2D)
	if get_parent().has_signal(emit):
		var err: Error = get_parent().emit_signal(emit)
		print(err)
	else:
		push_error("Signal ", emit, " doesn't exist!")

func set_ambience(ambience: WindsorAreaAmbience) -> void:
	assert(get_parent().get_parent() is WindsorSpawnPoint2D)
	var spawnpoint: WindsorSpawnPoint2D = get_parent().get_parent()
	spawnpoint.set_ambience(ambience)

func upgrade(amount: int, sender_id: int) -> void:
	assert(get_parent() is WindsorPlayer2D)
	var player: WindsorPlayer2D = get_parent()
	player.used_orbs.append(sender_id)
	player.max_flutters += amount

func reset_to(amount: int) -> void:
	assert(get_parent() is WindsorPlayer2D)
	var player: WindsorPlayer2D = get_parent()
	player.max_flutters = amount

func boost(boost_velocity: Vector2) -> void:
	assert(get_parent() is WindsorPlayer2D)
	var player: WindsorPlayer2D = get_parent()
	player.can_pound = true
	player.velocity = boost_velocity

func apply_velocity(velocity: Vector2) -> void:
	assert(get_parent() is WindsorPlayer2D)
	var player: WindsorPlayer2D = get_parent()
	player.velocity += velocity
