extends Resource
class_name WindsorSaveData

@export var orbs: PackedInt32Array
@export var spos: Vector2
@export var flut: int
@export var tick: int

func save_file() -> void:
	var string = self.serialize()
	if not string == "":
		var savefile = FileAccess.open_compressed("user://windsor.save", FileAccess.WRITE, FileAccess.COMPRESSION_FASTLZ)
		savefile.store_line(string)

func load_file() -> void:
	var savefile = FileAccess.open_compressed("user://windsor.save", FileAccess.READ, FileAccess.COMPRESSION_FASTLZ)
	var string = savefile.get_line()
	deserialize(string)

func serialize() -> String:
	var snapped_position: Vector2i = Vector2i(
		snapped(spos.x, 8),
		snapped(spos.y, 8)
	)
	
	spos = snapped_position
	
	if snapped_position == Vector2i.ZERO:
		return ""
	
	return JSON.stringify(JSON.from_native(self, true))

func reset() -> void:
	self.orbs = []
	self.flut = 0
	self.spos = Vector2(0, 0)
	self.tick = 0

func deserialize(data: String) -> void:
	var object = JSON.to_native(JSON.parse_string(data), true)
	print(data)
	
	if typeof(object) == TYPE_NIL:
		reset()
	else:
		orbs = object.orbs
		spos = object.spos
		flut = object.flut
		tick = object.tick
