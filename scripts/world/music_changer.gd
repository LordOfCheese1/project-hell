extends Area2D

@export var param_name : String


func _on_body_entered(body):
	if body.is_in_group("player"):
		mm.switch_fmod_event(param_name)
