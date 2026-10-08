@icon("res://addons/at-icons/node/stopwatch.svg")
extends Node
class_name Slowdown

@export var amount: float = 0.5
@export var speed: float = 0.01

func _init() -> void:
	Engine.time_scale = amount

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Engine.time_scale += speed
	if Engine.time_scale > 1:
		Engine.time_scale = 1
		free()
