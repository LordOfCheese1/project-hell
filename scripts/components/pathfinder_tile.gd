extends Area2D


func _on_body_entered(body):
	if body.is_in_group("wall"):
		$sprite.modulate = Color(1, 0, 0)
