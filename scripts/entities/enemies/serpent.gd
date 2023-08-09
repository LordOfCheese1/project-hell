extends "res://scripts/classes/entity_class.gd"

@export var points = 9
var attack_cooldown = 80
var active_attack = 0
var chomp_path = load("res://prefabs/projectiles/chomp_explosion.tscn")
var laser_path = load("res://prefabs/projectiles/sparklaser.tscn")
var fireball_scene = load("res://prefabs/projectiles/big_fireball.tscn")
var giraffe_scene = load("res://prefabs/entities/enemies/giraffe.tscn")
var current_attack_phase = 0
var spotted_player = false
var tongue_progress = 0.0
var current_attack = 0
var tongue_out = false
var laser_cooldown = 10
var giraffe_positions = [-846, -626]
var second_phase = false


func _ready():
	setup_entity(40, 0, 1)
	
	$body/neck.clear_points()
	for i in range(points):
		$body/neck.add_point(Vector2(0, 0))


func _physics_process(_delta):
	
	tongue_motions()
	
	if gv.player.position.distance_to(position) < 192 && !spotted_player:
		spot_player()
	
	var target_pos = Vector2(0, 0)
	for i in range(len($body/neck.points)):
		target_pos.y = clamp(gv.player.position.y - to_global($body/neck.points[i]).y, -256, 0) * (i + 1) * 0.1 - 48
		target_pos.x = lerp(target_pos.x, clamp(gv.player.position.x - to_global($body/neck.points[i]).x, -points * 4, points * 4) * (i + 1) * 0.06, 0.2)
		$looker.look_at(to_global(target_pos))
		$body/neck.points[i] = lerp($body/neck.points[i], $looker.transform.x * i * 8, 0.05)
	
	$body/head.position = $body/neck.points[len($body/neck.points) - 1]
	var prev_head_rot = $body/head.rotation_degrees
	$body/head.look_at(gv.player.position)
	$body/head.rotation_degrees = lerp(prev_head_rot, $body/head.rotation_degrees, 0.05)
	if gv.player.position.x > to_global($body/head.position).x:
		$body/head.scale.y = lerp($body/head.scale.y, 1.0, 0.2)
	else:
		$body/head.scale.y = lerp($body/head.scale.y, -1.0, 0.2)
	
	if !tongue_out:
		$body/head/lower_head.rotation_degrees = lerp($body/head/lower_head.rotation_degrees, 20.0 - (attack_cooldown / 5.0), 0.2)
		$body/head/upper_head.rotation_degrees = lerp($body/head/upper_head.rotation_degrees, -(80.0 - attack_cooldown * 0.8), 0.2)
	
	
	if attack_cooldown > 0:
		if active_attack <= 0 && spotted_player:
			attack_cooldown -= 1
	else:
		attack_cooldown = 100.0
		if current_attack == 0:
			active_attack = 60
			chomp_attack()
			current_attack = 1
		elif current_attack == 1:
			laser_cooldown = 20
			active_attack = 100
			current_attack = 2
			tongue_out = true
		elif current_attack == 2:
			active_attack = 80
			current_attack = 0
			fire_attack()
	
	if active_attack > 0:
		active_attack -= 1
	else:
		tongue_out = false
	
	if tongue_out:
		$body/head/lower_head.rotation_degrees = lerp($body/head/lower_head.rotation_degrees, 60.0, 0.2)
		$body/head/upper_head.rotation_degrees = lerp($body/head/upper_head.rotation_degrees, -60.0, 0.2)
		tongue_progress = lerp(float(tongue_progress), 1.0, 0.1)
		if laser_cooldown > 0:
			laser_cooldown -= 1
		else:
			laser_cooldown = 8
			shoot_laser()
		
	else:
		tongue_progress = lerp(float(tongue_progress), 0.0, 0.1)
	
	
	$hitbox.rotation_degrees = $body/head.rotation_degrees
	$hitbox.position = $body/head.position
	
	
	if hp <= 20 && !second_phase:
		second_phase = true
		for i in giraffe_positions:
			var giraffe = giraffe_scene.instantiate()
			giraffe.position = Vector2(i, 1552)
			giraffe.points = 10
			get_tree().current_scene.call_deferred("add_child", giraffe)
	
	
	entity_update()


func spot_player():
	spotted_player = true
	mm.switch_fmod_event("LVL2Boss")


func chomp_attack():
	var orig_head_transform = $body/head.transform.x
	for i in range(9):
		var chomp_inst = chomp_path.instantiate()
		chomp_inst.get_child(0).ignore_in_detection.append(self)
		chomp_inst.position = $body/head.global_position + orig_head_transform * 10 + orig_head_transform * 12 * i
		get_tree().current_scene.add_child(chomp_inst)
		await get_tree().create_timer(0.02).timeout


func fire_attack():
	var fireball = fireball_scene.instantiate()
	fireball.rotation_degrees = $body/head.rotation_degrees
	fireball.get_child(0).ignore_in_detection.append(self)
	fireball.global_position = $body/head.global_position
	get_tree().current_scene.call_deferred("add_child", fireball)


func shoot_laser():
	var laser_inst = laser_path.instantiate()
	laser_inst.position = $body/eye.global_position
	laser_inst.rotation_degrees = $body/eye.rotation_degrees
	laser_inst.get_child(0).ignore_in_detection.append(self)
	get_tree().current_scene.add_child(laser_inst)


func tongue_motions():
	var prev_eye_rot = $body/eye.rotation_degrees
	$tongue_looker.position = $body/head.position
	$body/eye.position = $tongue_looker.position + $tongue_looker.transform.x * 24 * tongue_progress
	if tongue_progress > 0:
		var prev_rot = $tongue_looker.rotation_degrees
		if gv.player != null:
			$tongue_looker.look_at(gv.player.position)
		
		$tongue_looker.rotation_degrees = lerp(prev_rot, $tongue_looker.rotation_degrees, 0.2)
		
		$body/tongue.position = $body/head.position
		$body/tongue.points[0] = Vector2(0, 0)
		$body/tongue.points[9] = $tongue_looker.transform.x * 24 * tongue_progress
		
		for i in range(len($body/tongue.points) - 2):
			$body/tongue.points[i + 1] += ($body/tongue.points[i] - $body/tongue.points[i + 1]) * 0.4 #Snap towards previous point
			$body/tongue.points[i + 1] += ($body/tongue.points[i + 2] - $body/tongue.points[i + 1]) * 0.4 #Snap towards next point
		
		$body/eye.look_at(gv.player.position)
		$body/eye.rotation_degrees = lerp(prev_eye_rot, $body/eye.rotation_degrees, 0.1)


func _on_hitbox_has_been_hit():
	hit()
