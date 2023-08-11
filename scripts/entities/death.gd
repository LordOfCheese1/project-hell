extends "res://scripts/classes/entity_class.gd"

var prev_pos = Vector2(0, 0)

func _physics_process(delta):
	prev_pos = global_position
	position = get_global_mouse_position()
	
	beard_movements(delta)


func beard_movements(delta : float):
	var prev_point = Vector2(0, 0)
	$beard.points[0] = Vector2(0, 0)
	prev_point = $beard.points[0]
	for i in $beard.get_point_count() - 1:
		$beard.points[i + 1] += (prev_pos - global_position)
		
		if $beard.points[i + 1].distance_to(prev_point) > 2:
			$beard.points[i + 1] = lerp($beard.points[i + 1], prev_point, 0.5)
		$beard.points[i + 1].y += 2
		
		prev_point = $beard.points[i + 1]
