extends Resource
class_name WindsorSaveData

@export var unlocked_orbs: PackedInt32Array
@export var safe_position: Vector2
@export var flutters: int
@export var ticks: int

func serialize() -> PackedByteArray:
	var snapped_position: Vector2i = Vector2i(
		snapped(safe_position.x, 8),
		snapped(safe_position.y, 8)
	)
	
	var return_bytes = PackedByteArray()
	
	safe_position = snapped_position
	return_bytes.encode_var(0, self, true)
	
	print(return_bytes)
	
	return return_bytes

func reset() -> void:
	self.unlocked_orbs = []
	self.flutters = 0
	self.safe_position = Vector2(0, 0)
	self.ticks = 0

func deserialize(data: PackedByteArray) -> void:
	var deserialized_object := data.decode_var(0, true)
	
	self.safe_position = Vector2(0, 0)
	self.flutters = 0
	self.ticks = 0
	self.unlocked_orbs = PackedInt32Array([])
	
	if deserialized_object:
		if deserialized_object.safe_position:
			self.safe_position = deserialized_object.safe_position
		if deserialized_object.flutters:
			self.flutters = deserialized_object.flutters
		if deserialized_object.ticks:
			self.ticks = deserialized_object.ticks
		if deserialized_object.safe_position:
			self.unlocked_orbs = deserialized_object.unlocked_orbs
