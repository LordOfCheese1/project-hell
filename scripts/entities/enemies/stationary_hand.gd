extends "res://scripts/classes/entity_class.gd"

var lower_hand_offset = Vector2(0, -64)
var spotted_player = false
var attack_cooldown = 90


func _ready():
	setup_entity(10.0, 1, 1)


func _physics_process(_delta):
	
	var prev_part : Node
	for i in $hand_parts.get_children():
		var prev_rot = i.rotation_degrees
		if prev_part != null:
			i.position = prev_part.transform.x * 28
			if gv.player != null:
				i.look_at(gv.player.position)
		elif gv.player != null:
			i.look_at(gv.player.position + lower_hand_offset)
		i.rotation_degrees = lerp(prev_rot, i.rotation_degrees, 0.1)
		
		prev_part = i
	
	for i in grabbed_items:
		i.position = $hand_parts/upper_arm.global_position + $hand_parts/upper_arm.transform.x * 10
		if gv.player != null:
			i.look_at(gv.player.position)
	
	if grabbed_items == []:
		grab_item()
	
	lower_hand_offset = lerp(lower_hand_offset, Vector2(0, -64), 0.1)
	if gv.player != null:
		$looker.look_at(gv.player.position)
	
	if spotted_player:
		if attack_cooldown > 0:
			attack_cooldown -= 1
		else:
			attack_cooldown = 90
			grabbed_items[0].use()
			lower_hand_offset.y = 24


func _process(_delta):
	if hp <= 0.0 && !is_dead:
		die(4)
		is_dead = true
		grabbed_items[0].is_grabbed = false
		grabbed_items[0].grabbed_entity = null
		grabbed_items = []
		call_deferred("free")


func grab_item():
	if $item_grab_area.items_in_range != [] && $item_grab_area.items_in_range[0].grabbed_entity == null:
		$item_grab_area.items_in_range[0].grab(self)
		$item_grab_area.refresh()


func _on_hitbox_has_been_hit():
	if !spotted_player:
		spotted_player = true
	lower_hand_offset = Vector2(($looker.transform.x.x / abs($looker.transform.x.x)) * -128, 0)
	$anim.play("hit")


func _on_player_detector_player_entered():
	spotted_player = true
