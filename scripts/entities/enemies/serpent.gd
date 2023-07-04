extends "res://scripts/classes/entity_class.gd"

@export var points = 9
var attack_cooldown = 80
var active_attack = 0
var chomp_path = load("res://prefabs/projectiles/chomp_explosion.tscn")


func _ready():
	setup_entity(50, 0, 1)
	
	$body/neck.clear_points()
	for i in range(points):
		$body/neck.add_point(Vector2(0, 0))

func _physics_process(_delta):
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
		if active_attack <= 0:
			attack_cooldown -= 1
	else:
		attack_cooldown = 80
		active_attack = 60
		chomp_attack()
	
	if active_attack > 0:
		active_attack -= 1


func chomp_attack():
	var orig_head_transform = $body/head.transform.x
	for i in range(9):
		var chomp_inst = chomp_path.instantiate()
		chomp_inst.position = $body/head.global_position + orig_head_transform * 10 + orig_head_transform * 12 * i
		get_tree().current_scene.add_child(chomp_inst)
		await get_tree().create_timer(0.02).timeout
