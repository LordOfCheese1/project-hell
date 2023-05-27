extends Node2D


var desired_head_rot = 0
var is_doing_something = false


func _physics_process(_delta):
	$lower_neck.look_at(Vector2(gv.player.position.x + position.x * 5, gv.player.position.y - 80 + position.y * 10))
	$upper_neck.look_at(Vector2(gv.player.position.x + position.x * 5, gv.player.position.y - 24 + position.y * 10))
	
	$upper_neck.position = $lower_neck.transform.x * 27
	
	
	$screw.position = $upper_neck.position + $upper_neck.transform.x * 22
	$screw/upper_jaw.rotation_degrees = lerp($screw/upper_jaw.rotation_degrees, float(clamp(-92 - -$screw.global_position.distance_to(gv.player.position), -90, 0)), 0.05)
	$screw/lower_jaw.rotation_degrees = lerp($screw/lower_jaw.rotation_degrees, float(clamp(80 + -$screw.global_position.distance_to(gv.player.position), 0, 64)), 0.05)
	var prev_screw_rot = $screw.rotation_degrees
	$screw.look_at(gv.player.position)
	if !is_doing_something:
		desired_head_rot = $screw.rotation_degrees
	$screw.rotation_degrees = lerp(prev_screw_rot, desired_head_rot, randf_range(0.05, 0.3))
	
	if gv.player.position.x > $screw.global_position.x:
		$screw.scale.y = 1
	else:
		$screw.scale.y = -1
