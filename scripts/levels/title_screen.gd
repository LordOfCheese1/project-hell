extends Node2D

func _ready():
	se.visibility = 0.0


func _physics_process(_delta):
	if $play.is_hovered:
		$play.scale = lerp($play.scale, Vector2(1.3, 1.3), 0.1)
		se.get_node("tentacles").visible = true
		se.get_node("tentacles").modulate.a = lerp(se.get_node("tentacles").modulate.a, 1.0, 0.02)
	else:
		$play.scale = lerp($play.scale, Vector2(1, 1), 0.1)
		se.get_node("tentacles").visible = false
		se.get_node("tentacles").modulate.a = lerp(se.get_node("tentacles").modulate.a, 0.0, 0.08)
	
	
	if $quit.is_hovered:
		$quit.scale = lerp($quit.scale, Vector2(1.3, 1.3), 0.1)
	else:
		$quit.scale = lerp($quit.scale, Vector2(1, 1), 0.1)
	
	
	if $delete_save.is_hovered:
		$delete_save.scale = lerp($delete_save.scale, Vector2(1.3, 1.3), 0.1)
	else:
		$delete_save.scale = lerp($delete_save.scale, Vector2(1, 1), 0.1)


func _on_play_clicked():
	se.get_node("tentacles").modulate.a = 0.0
	se.get_node("tentacles").visible = false
	sv.load_values(true)
	sv.switch_scene(sv.values["current_scene"], Vector2(sv.values["pl_pos_x"], sv.values["pl_pos_y"]), false)


func _on_quit_clicked():
	get_tree().quit()


func _on_delete_save_clicked():
	sv.delete_save()
