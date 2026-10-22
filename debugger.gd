@tool
extends Node
class_name WindsorDebugger

@export var debug_enabled: bool = true
@export var savefile: WindsorSaveData
@export var spawn_point: WindsorSpawnPoint2D 
@export_tool_button("Reset Save File") var reset: Callable = reset_save

func reset_save() -> void:
	var save_file: FileAccess = FileAccess.open("user://windsor.save", FileAccess.WRITE)
	while not save_file.store_line(""):
		continue

func _ready() -> void:
	if debug_enabled:
		spawn_point.attached_debugger = get_node(get_path())
		print(savefile.serialize())
