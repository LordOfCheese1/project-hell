extends Node2D

@export var size : Vector2
var is_hovered = false
signal clicked


func _physics_process(delta):
	if abs(global_position.x - get_global_mouse_position().x) < size.x && abs(global_position.y - get_global_mouse_position().y) < size.y:
		is_hovered = true
	elif abs(global_position.x - gv.cursor_pos.x) < size.x && abs(global_position.y - gv.cursor_pos.y) < size.y:
		is_hovered = true
	else:
		is_hovered = false
	
	if is_hovered:
		if Input.is_action_just_pressed("click"):
			emit_signal("clicked")
