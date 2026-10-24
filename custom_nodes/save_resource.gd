extends Resource
class_name WindsorSaveData

@export var orbs: PackedInt32Array
@export var spos: Vector2
@export var flut: int
@export var tick: int

func save_file() -> void:
	var save_string = self.serialize()
	FileAccess.open("user://windsor.save", FileAccess.WRITE_READ).store_line(save_string)

func load_file() -> void:
	var save_string = FileAccess.get_file_as_string("user://windsor.save")
	deserialize(save_string)

func serialize() -> String:
	var snapped_position: Vector2i = Vector2i(
		snapped(spos.x, 8),
		snapped(spos.y, 8)
	)
	
	spos = snapped_position
	
	return JSON.stringify(JSON.from_native(self, true))

func reset() -> void:
	self.orbs = []
	self.flut = 0
	self.spos = Vector2(0, 0)
	self.tick = 0

func deserialize(data: String) -> void:
	var object = JSON.to_native(JSON.parse_string(data), true)
	
	if typeof(object) == TYPE_NIL:
		reset()
	else:
		orbs = object.orbs
		spos = object.spos
		flut = object.flut
		tick = object.tick
