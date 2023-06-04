extends Area2D

@export var event: EventAsset
var instance: EventInstance
enum MusicArea {MUSIC1, MUSIC2}
@export_enum(MusicArea) var musicArea


func _ready():
	
	instance = RuntimeManager.create_instance(event)
	instance.start()
	

func _on_body_entered(body):
	if body.is_in_group("Player"):
		instance.set_parameter_by_name_with_label("area", param_id, false)
