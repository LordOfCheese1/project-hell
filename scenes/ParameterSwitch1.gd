extends StudioParameterTrigger



@export_range(0.0, 1.0) var MusicArea: int

func _on_music_trigger_1_body_entered(body):
	if body.is_in_group("Player"):
		trigger()
		pass
