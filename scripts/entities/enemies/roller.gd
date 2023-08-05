extends "res://scripts/classes/entity_class.gd"

var max_speed = 100
var spotted_player = false
var current_box_pos = -17
var cooldown = 20
var dir_to_player = 0
var projectile_scene = load("res://prefabs/projectiles/energy_spark.tscn")
var attack_cooldown = 0


func _ready():
	setup_entity(12.0, 0, 1)


func _physics_process(delta):
	move_and_slide()
	
	if gv.player != null && !spotted_player:
		if abs(gv.player.position.x - position.x) < 128 && abs(gv.player.position.y - position.y) < 64:
			spotted_player = true
	
	if velocity.y < gravity:
		velocity.y += gravity * delta
	
	if gv.player != null:
		dir_to_player = (gv.player.position.x - position.x) / abs(gv.player.position.x - position.x)
	if spotted_player:
		velocity.x = lerp(velocity.x, dir_to_player * max_speed, 0.01)
	
	$wheel.rotation_degrees += velocity.x * 0.2
	var prev_body_rot = $body.rotation_degrees
	$body.rotation_degrees = velocity.x * 0.5
	$body.rotation_degrees = lerp(prev_body_rot, $body.rotation_degrees, 0.15)
	
	if cooldown > 0:
		cooldown -= 1
	elif spotted_player:
		cooldown = snapped(max_speed - abs(velocity.x * 0.95), 1)
		swap_box_pos()
	
	$body/box2.position.y = lerp($body/box2.position.y, float(current_box_pos), 0.2)
	
	var prev_head_rot = $body/box2/head.rotation_degrees
	if gv.player != null:
		$body/box2/head.look_at(gv.player.position)
	$body/box2/head.rotation_degrees = lerp(prev_head_rot, $body/box2/head.rotation_degrees, 0.2)
	
	
	if spotted_player:
		if attack_cooldown > 0:
			attack_cooldown -= 1
		elif position.distance_to(gv.player.position) < 64:
			attack_cooldown = 50
			attack()
	
	entity_update()
	
	if hp <= 0:
		die(10)
		call_deferred("free")


func swap_box_pos():
	if current_box_pos == -13:
		current_box_pos = -17
	elif current_box_pos == -17:
		current_box_pos = -13


func _on_hitbox_has_been_hit():
	velocity.x = -dir_to_player * max_speed
	velocity.y = -60
	hit()


func attack():
	velocity.x = 0
	var projectile_inst = projectile_scene.instantiate()
	projectile_inst.position = $body/box2/head.global_position
	projectile_inst.look_at(gv.player.position)
	projectile_inst.velocity = projectile_inst.transform.x * (100 + abs(velocity.x))
	projectile_inst.get_child(0).ignore_in_detection.append($body)
	get_tree().current_scene.add_child(projectile_inst)
