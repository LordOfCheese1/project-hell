extends Node2D


func _physics_process(_delta):
	
	
	var prev_lower_rot = $lower_neck.rotation_degrees
	var prev_upper_rot = $lower_neck.rotation_degrees
	$lower_neck.look_at(Vector2(gv.player.position.x + position.x * 5, gv.player.position.y - 80 + position.y * 10))
	$upper_neck.look_at(Vector2(gv.player.position.x + position.x * 5, gv.player.position.y - 24 + position.y * 10))
	#$lower_neck.rotation_degrees = lerp(prev_lower_rot,  $lower_neck.rotation_degrees, 0.1)
	#$upper_neck.rotation_degrees = lerp(prev_upper_rot,  $upper_neck.rotation_degrees, 0.1)
	$upper_neck.position = $lower_neck.transform.x * 27
	
	
	$screw.position = $upper_neck.position + $upper_neck.transform.x * 22
	$screw/upper_jaw.rotation_degrees = lerp($screw/upper_jaw.rotation_degrees, float(clamp(-92 - -$screw.global_position.distance_to(gv.player.position), -90, 0)), 0.05)
	$screw/lower_jaw.rotation_degrees = lerp($screw/lower_jaw.rotation_degrees, float(clamp(80 + -$screw.global_position.distance_to(gv.player.position), 0, 64)), 0.05)
	var prev_screw_rot = $screw.rotation_degrees
	$screw.look_at(gv.player.position)
	var new_screw_rot = $screw.rotation_degrees
	$screw.rotation_degrees = prev_screw_rot
	$screw.rotation_degrees = lerp(prev_screw_rot, new_screw_rot, 0.3)
	
	if gv.player.position.x > $screw.global_position.x:
		$screw.scale.y = 1
	else:
		$screw.scale.y = -1
