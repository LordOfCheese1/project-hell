extends "res://scripts/classes/entity_class.gd"

var spotted_player = false
var attack_cooldown = 2


func _ready():
	setup_entity(5, 1, 1)


func _physics_process(delta):
	move_and_slide()
	
	var old_rot = 0.0
	old_rot = $looker.rotation_degrees
	$looker.look_at(Vector2(gv.player.position.x, gv.player.position.y - 64))
	$looker.rotation_degrees = lerp(old_rot, $looker.rotation_degrees, 0.1)
	
	velocity = lerp(velocity, $looker.transform.x * 100, 0.1)
	
	
	if grabbed_items == []:
		grab_item()
	else:
		for i in grabbed_items:
			i.position = $parts/upper_arm.global_position + $parts/upper_arm.transform.x * 12
			if gv.player != null:
				i.look_at(gv.player.position)
	
	
	if attack_cooldown > 0:
		attack_cooldown -= delta
	else:
		attack_cooldown = 0.5
		attack()
	
	
	var prev_rots = [0.0, 0.0]
	prev_rots[0] = $parts/lower_arm.rotation_degrees
	prev_rots[1] = $parts/upper_arm.rotation_degrees
	$parts/lower_arm.look_at(Vector2(gv.player.position.x, gv.player.position.y + 80))
	$parts/upper_arm.look_at(gv.player.position)
	$parts/lower_arm.rotation_degrees = lerp(prev_rots[0], $parts/lower_arm.rotation_degrees, 0.1)
	$parts/upper_arm.rotation_degrees = lerp(prev_rots[1], $parts/upper_arm.rotation_degrees, 0.1)
	$parts/body.rotation_degrees = lerp($parts/body.rotation_degrees, velocity.x / 4, 0.2)
	$parts/upper_arm.position = $parts/lower_arm.position + $parts/lower_arm.transform.x * 17
	
	$parts/body/left_jet.rotation_degrees = lerp($parts/body/left_jet.rotation_degrees, abs(velocity.x), 0.1)
	$parts/body/right_jet.rotation_degrees = lerp($parts/body/right_jet.rotation_degrees, -abs(velocity.x), 0.1)


func _process(delta):
	if hp <= 0 && !is_dead:
		print(grabbed_items)
		die(6)
		is_dead = true
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
	velocity = $looker.transform.x * -100
