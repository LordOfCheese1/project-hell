extends "res://scripts/classes/entity_class.gd"

func _ready():
	setup_entity(20, 0, 1)


func _physics_process(delta):
	move_and_slide()
	
	$looker.look_at(Vector2(gv.player.position.x, gv.player.posiiton.y - 64))
	velocity = $looker.transform.x * 80
	
	
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
