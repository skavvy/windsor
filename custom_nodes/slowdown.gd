@icon("res://addons/at-icons/node/stopwatch.svg")
extends Node
class_name Slowdown

@export var amount: float = 0.5
@export var speed: float = 0.01
@export var invert: bool = false
var in_process: bool
@export var autostart: bool = true

func start() -> void:
	in_process = true
	if not invert:
		Engine.time_scale = amount

func _ready() -> void:
	if autostart:
		in_process = true
		if not invert:
			Engine.time_scale = amount

func _exit_tree() -> void:
	in_process = false
	Engine.time_scale = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if in_process:
		if invert:
			Engine.time_scale -= speed
			if Engine.time_scale <= amount:
				Engine.time_scale = amount
				queue_free()
		else:
			Engine.time_scale += speed
			if Engine.time_scale >= 1:
				Engine.time_scale = 1
				queue_free()
