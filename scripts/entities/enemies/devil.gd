extends CharacterBody2D


func _physics_process(delta):
	move_and_slide()
	
	
	velocity.y = lerp(velocity.y, (gv.player.position.y - 48) - position.y, 0.1)
	velocity.x = lerp(velocity.x, gv.player.position.x - position.x, 0.1)
	
	
	var prev_rots = [0.0, 0.0]
	prev_rots[0] = $parts/lower_arm.rotation_degrees
	prev_rots[1] = $parts/upper_arm.rotation_degrees
	$parts/lower_arm.look_at(Vector2(gv.player.position.x, gv.player.position.y + 80))
	$parts/upper_arm.look_at(gv.player.position)
	$parts/lower_arm.rotation_degrees = lerp(prev_rots[0], $parts/lower_arm.rotation_degrees, 0.1)
	$parts/upper_arm.rotation_degrees = lerp(prev_rots[1], $parts/upper_arm.rotation_degrees, 0.1)
	$parts/body.rotation_degrees = velocity.x / 4
	$parts/upper_arm.position = $parts/lower_arm.position + $parts/lower_arm.transform.x * 17
	
	$parts/body/left_jet.rotation_degrees = abs(velocity.x)
	$parts/body/right_jet.rotation_degrees = -abs(velocity.x)
