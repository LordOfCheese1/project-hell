extends Area2D

@export var event: EventAsset
@export_range(0.0, 1.0) var musicArea: int
var instance = EventInstance
var MusicArea1
var MusicArea2


func _ready():
	instance = RuntimeManager.create_instance(event)
	instance.start()


func _on_trigger_area_1_area_name(areaName):
	MusicArea1 = areaName
func _on_trigger_area_1_body_entered(body):
	instance.set_parameter_by_name_with_label("area", MusicArea1, false)


func _on_trigger_area_2_area_name(areaName):
	MusicArea2 = areaName
func _on_trigger_area_2_body_entered(body):
	instance.set_parameter_by_name_with_label("area", MusicArea2, false)
	
	
	
