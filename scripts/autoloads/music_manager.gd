extends Node2D

@export var event : EventAsset
var instance : EventInstance


func _ready():
	instance = RuntimeManager.create_instance(event)
	instance.start()


func switch_param(value : String):
	instance.set_parameter_by_name_with_label("Intensity", value, false)


func switch_scene(value : String):
	instance.set_parameter_by_name_with_label("Level", value, false)
