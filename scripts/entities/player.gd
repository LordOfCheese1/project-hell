extends "res://scripts/classes/entity_class.gd"

var max_speed = 120
var accel = 0.15
var jump_power = 8
var jump_held_for = 0
var is_jumping = false
var jump_buffer = 0
var max_jump_buffer = 8
var look_dir_x = 1
var look_dir_y = 0


func _ready():
	setup_entity(5.0, 2)


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
	
	if Input.is_action_just_pressed("grab"):
		if $item_grab_area.items_in_range != []:
			$item_grab_area.items_in_range[0].grab(self)
	
	for i in range(len(grabbed_items)):
		grabbed_items[i].position = lerp(grabbed_items[i].position, Vector2(position.x + (look_dir_x * 16), position.y + (look_dir_y * 16)), 0.3)
	
	if velocity.x != 0:
		look_dir_x = velocity.x / abs(velocity.x)
	
	look_dir_y = Input.get_axis("up", "down")


func jump():
	jump_held_for = 2
	velocity.y = -10
	is_jumping = true
