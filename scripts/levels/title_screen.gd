extends Node2D

func _physics_process(delta):
	if $play.is_hovered:
		$play.scale = lerp($play.scale, Vector2(1.3, 1.3), 0.1)
		se.get_node("tentacles").visible = true
		se.get_node("tentacles").modulate.a = lerp(se.get_node("tentacles").modulate.a, 1.0, 0.02)
	else:
		$play.scale = lerp($play.scale, Vector2(1, 1), 0.1)
		se.get_node("tentacles").visible = false
		se.get_node("tentacles").modulate.a = lerp(se.get_node("tentacles").modulate.a, 0.0, 0.08)
