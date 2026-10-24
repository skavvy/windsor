extends Resource
class_name Ambience

@export_group("Sky")
@export_subgroup("Clouds")
@export var cloud_speed: float
@export var cloud_color: Color = Color("323232")
@export_subgroup("Background")
@export var upper_sky_color: Color = Color("3c4a57")
@export var lower_sky_color: Color = Color("b9dcfb")
@export_subgroup("Effects")
@export var lightning: bool = false
@export_group("Soundscape")
@export var soundscape: AudioStream
