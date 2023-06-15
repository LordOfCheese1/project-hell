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
var grabbed_for = 0
var item_use_cooldown = 0
var max_item_use_cooldown = 25


func _ready():
	gv.player = self
	setup_entity(5.0, 2)
	add_to_group("player")


func _physics_process(delta):
	move_and_slide()
	
	var x_input = Input.get_axis("left", "right")
	velocity.x = lerp(velocity.x, x_input * max_speed, accel)
	
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = 8
	if jump_buffer > 0:
		jump_buffer -= 1
	
	if velocity.y < gravity:
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
		if len(grabbed_items) < 2:
			attempt_item_grab()
	
	if Input.is_action_just_released("grab"):
		grabbed_items.reverse()
	
	if Input.is_action_pressed("grab"):
		grabbed_for += 1
		if grabbed_for > 90:
			grabbed_for = 0
			attempt_attach()
	else:
		grabbed_for = 0
	
	if Input.is_action_pressed("use_item"):
		attempt_item_use()
	
	for i in range(len(grabbed_items)):
		grabbed_items[i].position = lerp(grabbed_items[i].position, Vector2(position.x + (look_dir_x * 14) + grabbed_items.find(grabbed_items[i]) * look_dir_x * -28, position.y + (look_dir_y * 12)), 0.3)
		grabbed_items[i].look_at(position + Vector2(look_dir_x * 64, look_dir_y * 64))
	
	if velocity.x != 0:
		look_dir_x = velocity.x / abs(velocity.x)
	
	look_dir_y = Input.get_axis("up", "down")
	$body/upper_body.rotation_degrees = (velocity.x / 6) - look_dir_x * item_use_cooldown * 1.5
	$body/upper_body.scale.x = -look_dir_x
	
	if item_use_cooldown > 0:
		item_use_cooldown -= 1


func _process(_delta):
	pass


func jump():
	jump_held_for = 2
	velocity.y = -10
	is_jumping = true


func attempt_item_grab():
	$item_grab_area.refresh()
	if $item_grab_area.items_in_range != []:
		$item_grab_area.items_in_range[0].grab(self)
		$item_grab_area.refresh()


func attempt_item_use():
	if grabbed_items != [] && item_use_cooldown <= 0:
		item_use_cooldown = max_item_use_cooldown
		grabbed_items[0].use()


func attempt_attach():
	$item_grab_area.refresh()
	var attached_items_amt = 0
	for i in grabbed_items:
		if i.has_attachment:
			attached_items_amt += 1
	if len(grabbed_items) > 1 && attached_items_amt < 1:
		grabbed_items[1].attach_to(grabbed_items[0])
		gv.spawn_explosion(12, grabbed_items[0].global_position, load("res://textures/particles/spark.png"), -0.06, -0.06, 4, 0, 0, 80)
		$item_grab_area.refresh()


func _on_hitbox_has_been_hit():
	$anim.play("hit")


func request_grabbed_items():
	var requested_items = []
	for i in grabbed_items:
		if i.self_attachment != null:
			requested_items.append([i.scene_file_path, i.self_attachment.scene_file_path])
		else:
			requested_items.append(i.scene_file_path)
	return requested_items
