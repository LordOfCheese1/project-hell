extends "res://scripts/classes/entity_class.gd"

@export var points = 9
var attack_cooldown = 80
var active_attack = 0
var chomp_path = load("res://prefabs/projectiles/chomp_explosion.tscn")
var current_attack_phase = 0
var spotted_player = false
var tongue_progress = 0


func _ready():
	setup_entity(50, 0, 1)
	
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
	
	$body/head/lower_head.rotation_degrees = lerp($body/head/lower_head.rotation_degrees, 20.0 - (attack_cooldown / 4), 0.2)
	$body/head/upper_head.rotation_degrees = lerp($body/head/upper_head.rotation_degrees, -(80.0 - attack_cooldown), 0.2)
	
	
	if attack_cooldown > 0:
		if active_attack <= 0 && spotted_player:
			attack_cooldown -= 1
	else:
		attack_cooldown = 80
		active_attack = 60
		chomp_attack()
	
	if active_attack > 0:
		active_attack -= 1


func spot_player():
	spotted_player = true


func chomp_attack():
	var orig_head_transform = $body/head.transform.x
	for i in range(9):
		var chomp_inst = chomp_path.instantiate()
		chomp_inst.position = $body/head.global_position + orig_head_transform * 10 + orig_head_transform * 12 * i
		get_tree().current_scene.add_child(chomp_inst)
		await get_tree().create_timer(0.02).timeout


func tongue_motions():
	$tongue_looker.position = $body/head.position
	$body/eye.position = $tongue_looker.position + $tongue_looker.transform.x * 48 * tongue_progress
	if tongue_progress > 0:
		var prev_rot = $tongue_looker.rotation_degrees
		if gv.player != null:
			$tongue_looker.look_at(gv.player.position)
		
		$tongue_looker.rotation_degrees = lerp(prev_rot, $tongue_looker.rotation_degrees, 0.2)
		
		$body/tongue.position = $body/head.position
		$body/tongue.points[0] = Vector2(0, 0)
		$body/tongue.points[9] = $tongue_looker.transform.x * 48 * tongue_progress
		
		for i in range(len($body/tongue.points) - 2):
			$body/tongue.points[i + 1] += ($body/tongue.points[i] - $body/tongue.points[i + 1]) * 0.4 #Snap towards previous point
			$body/tongue.points[i + 1] += ($body/tongue.points[i + 2] - $body/tongue.points[i + 1]) * 0.4 #Snap towards next point
		
		$body/eye.look_at(gv.player.position)
