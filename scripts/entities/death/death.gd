extends "res://scripts/classes/entity_class.gd"

var prev_pos = Vector2(0, 0)
var beard = null
var prev_body_rot = 0.0


func _ready():
	beard = get_node("head/beard")


func _physics_process(delta):
	prev_pos = beard.global_position
	prev_body_rot = $body.rotation_degrees
	
	$body.look_at(get_global_mouse_position())
	head_movements()
	beard_movements(delta)


func beard_movements(delta : float):
	var prev_point = Vector2(0, 0)
	beard.points[0] = Vector2(0, 0)
	prev_point = beard.points[0]
	for i in beard.get_point_count() - 1:
		beard.points[i + 1] += (prev_pos - beard.global_position)
		
		if beard.points[i + 1].distance_to(prev_point) > 2:
			beard.points[i + 1] = lerp(beard.points[i + 1], prev_point, 0.5)
		beard.points[i + 1].y += 2
		
		prev_point = beard.points[i + 1]


func head_movements():
	$neck.position = $body.position + $body.transform.x * 36
	$neck.rotation_degrees = lerp($neck.rotation_degrees, $body.rotation_degrees, 0.1)
	$head.position = $neck.position + $neck.transform.x * 23
	$head/tophat/eye.look_at(get_global_mouse_position())
	$head/tophat.rotation_degrees += prev_body_rot - $body.rotation_degrees
	$head/tophat.rotation_degrees = lerp($head/tophat.rotation_degrees, 0.0, 0.1)
