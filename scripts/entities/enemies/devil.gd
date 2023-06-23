extends "res://scripts/classes/entity_class.gd"

var spotted_player = false
var attack_cooldown = 50
var target_pos = Vector2(0, 0)

 
func _ready():
	setup_entity(8, 1, 1)
	target_pos = Vector2(position.x, position.y + 80)


func _physics_process(_delta):
	move_and_slide()
	
	var old_rot = 0.0
	old_rot = $looker.rotation_degrees
	if spotted_player:
		target_pos = Vector2(gv.player.position.x, gv.player.position.y - 64)
		$looker.look_at(Vector2(gv.player.position.x, gv.player.position.y - 64))
		$looker.rotation_degrees += randi_range(-10, 10)
	$looker.rotation_degrees = lerp(old_rot, $looker.rotation_degrees, 0.1)
	
	if spotted_player:
		velocity = lerp(velocity, $looker.transform.x * 100, 0.1)
	
	
	if grabbed_items == []:
		grab_item()
	else:
		for i in grabbed_items:
			i.position = $parts/upper_arm.global_position + $parts/upper_arm.transform.x * 12
			var prev_rot = i.rotation_degrees
			if gv.player != null && spotted_player:
				i.look_at(gv.player.position)
			else:
				i.look_at(target_pos)
			i.rotation_degrees = lerp(prev_rot, i.rotation_degrees, 0.1)
	
	
	if spotted_player:
		if attack_cooldown > 0:
			attack_cooldown -= 1
		else:
			attack_cooldown = 50
			attack()
	
	
	if !spotted_player && position.distance_to(gv.player.position) < 180:
		spotted_player = true
	
	
	var prev_rots = [0.0, 0.0]
	prev_rots[0] = $parts/lower_arm.rotation_degrees
	prev_rots[1] = $parts/upper_arm.rotation_degrees
	$parts/lower_arm.look_at(Vector2(target_pos.x, target_pos.y + 144))
	$parts/upper_arm.look_at(Vector2(target_pos.x, target_pos.y + 64))
	$parts/lower_arm.rotation_degrees = lerp(prev_rots[0], $parts/lower_arm.rotation_degrees, 0.1)
	$parts/upper_arm.rotation_degrees = lerp(prev_rots[1], $parts/upper_arm.rotation_degrees, 0.1)
	$parts/body.rotation_degrees = lerp($parts/body.rotation_degrees, velocity.x / 4, 0.2)
	$parts/upper_arm.position = $parts/lower_arm.position + $parts/lower_arm.transform.x * 17
	
	$parts/body/left_jet.rotation_degrees = lerp($parts/body/left_jet.rotation_degrees, abs(velocity.x), 0.1)
	$parts/body/right_jet.rotation_degrees = lerp($parts/body/right_jet.rotation_degrees, -abs(velocity.x), 0.1)
	
	entity_update()


func _process(_delta):
	if hp <= 0 && !is_dead:
		die(6)
		is_dead = true
		if len(grabbed_items) > 0:
			grabbed_items[len(grabbed_items) - 1].is_grabbed = false
			grabbed_items[len(grabbed_items) - 1].grabbed_entity = null
		grabbed_items = []
		call_deferred("free")


func grab_item():
	if $item_grab_area.items_in_range != [] && $item_grab_area.items_in_range[0].grabbed_entity == null:
		$item_grab_area.items_in_range[0].grab(self)
		$item_grab_area.refresh()


func attack():
	if grabbed_items != []:
		grabbed_items[0].use()


func _on_hitbox_has_been_hit():
	if !spotted_player:
		spotted_player = true
	velocity = $looker.transform.x * -100
	hit()
