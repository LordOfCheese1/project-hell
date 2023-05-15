extends "res://scripts/classes/entity_class.gd"


var max_speed = 100
var accel = 0.15
var jump_velocity = -245


func _physics_process(delta):
	move_and_slide()
	
	var x_input = Input.get_axis("left", "right")
	velocity.x = lerp(velocity.x, x_input * max_speed, accel)
	
	velocity.y += gravity * delta
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			jump()


func jump():
	velocity.y = jump_velocity
