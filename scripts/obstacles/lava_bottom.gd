extends Area2D

var is_onscreen = false


func _physics_process(delta):
	if is_onscreen:
		modulate.r = clamp(modulate.r + randf_range(-0.05, 0.05), 1, 1.5)


func _on_visible_on_screen_enabler_2d_screen_entered():
	is_onscreen = true


func _on_visible_on_screen_enabler_2d_screen_exited():
	is_onscreen = false
