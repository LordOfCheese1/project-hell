extends Node2D

@export var event : EventAsset
var instance : EventInstance


func _ready():
	instance = RuntimeManager.create_instance(event)
	instance.start() # Remove/Comment this out if you want your game to have no music

#change parameter within level music
func switch_level_param(value : String):
	instance.set_parameter_by_name_with_label("LevelVar", value, false)
#change parameter within boss music
func switch_boss_param(value : String):
	instance.set_parameter_by_name_with_label("Boss", value, false)
#switch global music
func switch_fmod_event(value : String):
	instance.set_parameter_by_name_with_label("MusicChange", value, false)
