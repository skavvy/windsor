extends Resource
class_name WindsorSaveData

@export var unlocked_orbs: PackedInt32Array
@export var safe_position: Vector2
@export var flutters: int

func serialize() -> String:
	var data = {
		"o": unlocked_orbs,
		"p": {
			"x": snapped(safe_position.x, 0.01),
			"y": snapped(safe_position.y, 0.01)
		},
		"f": flutters
	}
	return JSON.stringify(data)

func deserialize(json: String) -> void:
	var data = JSON.parse_string(json)
	if typeof(data) != TYPE_NIL:
		if data.has("o") and data.has("p") and data.has("f"):
			if data.p.has("x") and data.p.has("y"):
				self.unlocked_orbs = data.o
				self.flutters = data.f
				self.safe_position = Vector2(data.p.x, data.p.y)
	else:
		self.unlocked_orbs = []
		self.flutters = 0
		self.safe_position = Vector2(0, 0)
