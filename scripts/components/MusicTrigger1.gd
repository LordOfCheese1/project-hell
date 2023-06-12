extends Node2D

@export var event: EventAsset
var instance = EventInstance
var fmodParam1
var fmodParam2
var fmodParam3
var fmodParam4
var fmodParam5



func _ready():
	instance = RuntimeManager.create_instance(event)
	instance.start()
	instance.set_parameter_by_name_with_label("Intensity", "LowI", false)




#cerberus music dynamic change
func _on_area_2d_param_name(paramName1, paramName2, paramName3, paramName4, paramName5):
	fmodParam1 = paramName1
	fmodParam2 = paramName2
	fmodParam3 = paramName3
	fmodParam4 = paramName4
	fmodParam5 = paramName5
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("Intensity", fmodParam1, false)

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("Intensity", fmodParam2, false)

func _on_cerberus_has_died():
	instance.set_parameter_by_name_with_label("Intensity", fmodParam3, false)

#approch trigger
func _on_approach_trigger_body_entered(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("Intensity", fmodParam4, false)
