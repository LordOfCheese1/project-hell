extends Area2D

@export var event: EventAsset
var instance = EventInstance
var fmodParam1
var fmodParam2


func _ready():
	instance = RuntimeManager.create_instance(event)
	instance.start()
	instance.set_parameter_by_name_with_label("Intensity", "LowI", false)


func _on_trigger_area_1_param_name(paramName1, paramName2):
	fmodParam1 = paramName1
	fmodParam2 = paramName2
func _on_trigger_area_1_body_entered(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("Intensity", fmodParam1, false)	
	
func _on_trigger_area_1_body_exited(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("Intensity", fmodParam2, false)
