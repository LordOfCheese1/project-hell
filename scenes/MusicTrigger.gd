extends Area2D

@export var event: EventAsset
var description: EventDescription
var instance: EventInstance
var param_id
enum MusicArea {MUSIC1, MUSIC2}
@export_enum("MUSIC1", "MUSIC2") var musicChangeTo


func _ready():
	description = RuntimeManager.get_event_description(event)
	var param_description = description.get_parameter_description_by_name("area")
	param_id = param_description.id
	instance = description.create_instance()
	instance.start()
	

func _on_body_entered(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_id_with_label(param_id, "music 2", false)
