extends Sprite2D

var border = 65


func _physics_process(delta):
	if get_parent().get_parent().is_on_floor():
		rotation_degrees += (position.x / 2) * get_parent().get_parent().velocity.x / 8
		if rotation_degrees > border:
			rotation_degrees = -(border - 1)
		if rotation_degrees < -border:
			rotation_degrees = border - 1
	else:
		rotation_degrees = -(position.x / 2) * border
