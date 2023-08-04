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
var scrap = 0
var max_hp = 15.0
var sounds = {
	"hit" : [load("res://sfx/entities/player/hit/player_hit_0.wav")]
}


func _ready():
	$particle_spawner.alt_parent = $merge_icon
	gv.player = self
	setup_entity(15, 2, 0)
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
		if grabbed_for > 60:
			grabbed_for = 0
			attempt_attach()
	else:
		grabbed_for = 0
	
	if Input.is_action_pressed("use_item") && !Input.is_action_pressed("grab"):
		attempt_item_use()
	
	if Input.is_action_just_pressed("drop"):
		drop_item()
	
	for i in range(len(grabbed_items)):
		grabbed_items[i].position = lerp(grabbed_items[i].position, Vector2(position.x + (look_dir_x * 14) + grabbed_items.find(grabbed_items[i]) * look_dir_x * -28, position.y + (look_dir_y * 14)), 0.3)
		var prev_rot = grabbed_items[i].rotation_degrees
		grabbed_items[i].look_at(position + Vector2(look_dir_x * 64, look_dir_y * 64))
		grabbed_items[i].rotation_degrees = lerp(prev_rot, grabbed_items[i].rotation_degrees, 0.2)
	
	if velocity.x != 0:
		look_dir_x = velocity.x / abs(velocity.x)
	
	look_dir_y = Input.get_axis("up", "down")
	$body/upper_body.rotation_degrees = (velocity.x / 6) - look_dir_x * item_use_cooldown * 1.5
	$body/upper_body.scale.x = -look_dir_x
	
	if item_use_cooldown > 0:
		item_use_cooldown -= 1
	
	$body/upper_body/eyes.modulate.a = hp / max_hp
	
	var prev_alpha = $merge_icon.modulate.a
	var amt_merged_items = 0
	for i in grabbed_items:
		if i.has_attachment:
			amt_merged_items += 1
	
	if len(grabbed_items) == 2 && amt_merged_items == 0:
		if grabbed_for > 1:
			$progress_bar.rotation_degrees = grabbed_for * 6
			$particle_spawner.position = $progress_bar.transform.x * 12
			$particle_spawner.is_emitting = true
			$merge_icon.modulate.a = 1.0
		else:
			$particle_spawner.is_emitting = false
			$merge_icon.modulate.a = 0.0
	else:
		$particle_spawner.is_emitting = false
		$merge_icon.modulate.a = 0.0
	
	$merge_icon.modulate.a = lerp(prev_alpha, $merge_icon.modulate.a, 0.2)
	if $merge_icon.modulate.a < 0.25:
		for i in $merge_icon.get_children():
			i.call_deferred("free")
	
	se.visibility = lerp(se.visibility, (max_hp - hp) / 15, 0.1)
	
	entity_update()
	
	if hp > max_hp:
		hp = max_hp


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
		gv.spawn_explosion(24, grabbed_items[0].global_position, load("res://textures/particles/lighting_spark.png"), -0.05, -0.05, 4, 0, 0, 80)


func drop_item():
	if len(grabbed_items) > 0:
		grabbed_items[0].grabbed_entity = null
		grabbed_items[0].is_grabbed = false
		grabbed_items.remove_at(0)


func _on_hitbox_has_been_hit():
	hit()
	gv.hitstop(0.1)
	$hit.stream = sounds["hit"][randi_range(0, 0)]
	$hit.play(0.0)
	mm.switch_mix_event("Hurt", 0.0)
	mm.switch_mix_event("NotHurt", 0.5)


func request_grabbed_items():
	var requested_items = []
	for i in grabbed_items:
		if i.self_attachment != null:
			requested_items.append([i.scene_file_path, i.self_attachment.scene_file_path])
		else:
			requested_items.append(i.scene_file_path)
	return requested_items
