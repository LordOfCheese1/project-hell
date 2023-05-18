extends Sprite2D

var border = 50


func _physics_process(delta):
	if get_parent().get_parent().is_on_floor():
		rotation_degrees += Input.get_axis("left", "right") * 7
		if rotation_degrees > border:
			rotation_degrees = -(border - 1)
		if rotation_degrees < -border:
			rotation_degrees = border - 1
	else:
		rotation_degrees = -position.x * 11
