extends "res://scripts/classes/entity_class.gd"

var prev_pos = Vector2(0, 0)
var point_velocities = []


func _ready():
	for i in $beard.get_point_count() - 1:
		point_velocities.append(Vector2(0, 0))


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
		
		var force = ($beard.points[i + 1].distance_to(prev_point) - 4) * 5.0
		point_velocities[i] = (prev_point - $beard.points[i]) * force
		
		$beard.points[i + 1] += point_velocities[i]# * delta
		
		prev_point = $beard.points[i + 1]
