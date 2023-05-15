extends "res://scripts/classes/entity_class.gd"

var max_speed = 120
var accel = 0.15
var jump_power = 8
var jump_held_for = 0
var is_jumping = false
var jump_buffer = 0
var max_jump_buffer = 8


func _physics_process(delta):
	move_and_slide()
	
	var x_input = Input.get_axis("left", "right")
	velocity.x = lerp(velocity.x, x_input * max_speed, accel)
	
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 8
	if jump_buffer > 0:
		jump_buffer -= 1
	velocity.y += gravity * delta
	if is_on_floor():
		is_jumping = false
		if jump_buffer > 0:
			jump()
	else:
		if is_jumping && jump_held_for < 8 && jump_held_for != 0:
			if Input.is_action_pressed("jump"):
				jump_held_for += 1
			else:
				jump_held_for = 0
			velocity.y -= jump_held_for * jump_power


func jump():
	jump_held_for = 2
	velocity.y = -10
	is_jumping = true
