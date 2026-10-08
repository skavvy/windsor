extends Area2D
class_name PlayerInteractionArea2D

func send_signal(emit: String):
	if get_parent().has_signal(emit):
		get_parent().emit_signal(emit)
	else:
		push_error("Signal ", emit, " doesn't exist!")

func upgrade(amount: int, sender_id: int):
	get_parent().used_orbs.append(sender_id)
	get_parent().max_flutters += amount

func boost(boost: Vector2):
	get_parent().can_pound = true
	get_parent().velocity = boost

func apply_velocity(velocity: Vector2):
	get_parent().velocity += velocity
