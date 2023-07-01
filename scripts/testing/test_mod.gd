extends Node2D

var toggled_on = false


func _physics_process(delta):
	if Input.is_action_just_pressed("test"):
		toggled_on = !toggled_on
	
	if toggled_on:
		gv.player.position = get_global_mouse_position()
		gv.player.velocity = Vector2(0, 0)
