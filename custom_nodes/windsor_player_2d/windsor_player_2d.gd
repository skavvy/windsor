extends CharacterBody2D
class_name WindsorPlayer2D

const SPEED = 25
@export var JUMP_VELOCITY = -400.0
@export var MAX_RUN_SPEED = 400.0
@export var MAX_SPEED = 1000.0
var squash_and_stretch = 0.0
var can_pound = true
var can_jump_again = false
var flutters_midair: float = 0
var used_orbs: Array = [-1]
var on_edge: bool = false
var should_save: bool = true

@export var gravity: Vector2 
@export var max_flutters: int = 4

var spawn_position = Vector2(0, 0)
var last_safe_position: Vector2

signal dead

func _physics_process(delta: float) -> void:
	if $RayCast2D.is_colliding() and $RayCast2D2.is_colliding():
		on_edge = false
	else:
		on_edge = true
	
	var direction = Input.get_axis("game_left", "game_right")
	
	if is_on_floor_only():
		should_save = true
		if $DangerArea.has_overlapping_areas():
			for area in $DangerArea.get_overlapping_areas():
				if area.get_parent() is PolygonDeathplane2D:
					should_save = false
					break
	if on_edge:
		should_save = false
	if position == Vector2.ZERO:
		should_save = false
	if should_save:
		last_safe_position = position
	
	
	# Add the gravity.
	if not is_on_floor():
		if not is_on_wall_only():
			velocity += gravity * delta
		else:
			if velocity.y < 0:
				velocity += gravity * delta
			else:
				velocity += gravity/10 * delta
		if not can_pound:
			velocity.y += -JUMP_VELOCITY*0.2
			if velocity.y > -JUMP_VELOCITY * 2:
				velocity.y = -JUMP_VELOCITY * 2

	if Input.is_action_just_pressed("game_down") and not is_on_floor() and can_pound:
		can_pound = false

	# Handle walljump.
	if is_on_wall():
		can_pound = true
		if Input.is_action_just_pressed("game_jump"):
			velocity.x = (get_wall_normal().x * (-JUMP_VELOCITY / 2)) + ((velocity.y / 1.5) * get_wall_normal().x)
			velocity.y = JUMP_VELOCITY / 2
	
	if is_on_floor():
		if velocity.x > MAX_RUN_SPEED:
			velocity.x = MAX_RUN_SPEED
		elif velocity.x < -MAX_RUN_SPEED:
			velocity.x = -MAX_RUN_SPEED
	else:
		if velocity.x > MAX_SPEED:
			velocity.x = MAX_SPEED
		elif velocity.x < -MAX_SPEED:
			velocity.x = -MAX_SPEED

	if direction:
		velocity.x +=  direction * SPEED if is_on_floor() else direction * SPEED / 2
		$WalkParticles2D.direction = velocity
		if is_on_floor():
			$WalkParticles2D.emitting = true
		else:
			$WalkParticles2D.emitting = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED/1.5)
		
	if not is_on_floor():
		velocity.x = velocity.x / 1.025

	# Handle jump.
	if Input.is_action_just_pressed("game_jump"):
		if is_on_floor():
			if not can_pound:
				velocity.y = JUMP_VELOCITY * velocity.y
			else:
				velocity.y = JUMP_VELOCITY
		elif not is_on_wall():
			if flutters_midair < max_flutters:
				flutters_midair += 1
				var flutter_speed = (JUMP_VELOCITY * 1.1) + flutters_midair * (-JUMP_VELOCITY / max_flutters)
				velocity.y = flutter_speed
				if velocity.y > 10:
					velocity.y = 10

	if is_on_floor():
		flutters_midair = 0
		can_pound = true

	move_and_slide()

# technically rendering but not really
	$MeshInstance2D.texture.gradient.offsets = PackedFloat32Array([0.0, float(1.0 - float(flutters_midair) / max_flutters)])
	if $MeshInstance2D.texture.gradient.offsets[1] < 0.005:
		$MeshInstance2D.texture.gradient.offsets[1] = 0.005
	
	$MeshInstance2D.rotation = deg_to_rad(-90) + velocity.x/5000 + get_floor_normal().angle()
	$MeshInstance2D.skew = -velocity.x/5000
	$MeshInstance2D.position.y = velocity.x/2500 + 3
	
	if is_on_wall_only() and not is_on_floor():
		$MeshInstance2D.position.x = get_wall_normal().x * -squash_and_stretch / 2
	else:
		$MeshInstance2D.position.x = 0
	
	squash_and_stretch = move_toward(squash_and_stretch, velocity.y/50, 10)
		
	$MeshInstance2D.scale.y = 25 - squash_and_stretch
	$MeshInstance2D.scale.x = 25 + squash_and_stretch
	
	if $MeshInstance2D.scale.x < 10:
		$MeshInstance2D.scale.x = 10
	if $MeshInstance2D.scale.y < 10:
		$MeshInstance2D.scale.y = 10
		
	if $MeshInstance2D.scale.x < -10:
		$MeshInstance2D.scale.x = -10
	if $MeshInstance2D.scale.y < -10:
		$MeshInstance2D.scale.y = -10

func trigger_death() -> void:
	emit_signal("dead")
