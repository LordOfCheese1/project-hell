extends "res://scripts/classes/entity_class.gd"

@export var points = 9
@export var starting_offset = 0.0
var attack_cooldown = 80
var target_stinger_pos = 0.0
var is_attacking = false
var player_is_grabbed = false


func _ready():
	setup_entity(25, 0, 2)
	$neck.clear_points()
	for i in range(points):
		$neck.add_point(Vector2(0, 0))


func _physics_process(_delta):
	var target_pos = Vector2(0, 0)
	for i in range(len($neck.points)):
		target_pos.y = clamp(gv.player.position.y - to_global($neck.points[i]).y, -256, 0) * (i + 1) * 0.1 - 48
		target_pos.x = lerp(target_pos.x, clamp(gv.player.position.x - to_global($neck.points[i]).x, -80, 80) * (i + 1) * 0.06, 0.2)
		$looker.look_at(to_global(target_pos))
		$neck.points[i] = lerp($neck.points[i], $looker.transform.x * i * 8, 0.05)
	
	$head.position = $neck.points[len($neck.points) - 1]
	var prev_head_rot = $head.rotation_degrees
	$head.look_at(gv.player.position)
	$head.rotation_degrees = lerp(prev_head_rot, $head.rotation_degrees, 0.05)
	if gv.player.position.x > to_global($head.position).x:
		$head.flip_v = false
	else:
		$head.flip_v = true
	
	if starting_offset > 0:
		starting_offset -= 1
	
	if attack_cooldown > 0 && starting_offset <= 0 && position.distance_to(gv.player.position) < 160:
		attack_cooldown -= 1
	elif attack_cooldown <= 0:
		attack_cooldown = 80
		grab_player()
	
	if player_is_grabbed:
		gv.player.velocity = lerp(gv.player.velocity, Vector2(0, 0), 0.1)
		gv.player.position = lerp(gv.player.position, $head.global_position, 0.1)
	
	entity_update()


func grab_player():
	gv.spawn_explosion(24, $head.global_position + $head.transform.x * 6, load("res://textures/particles/small_lighting_spark.png"), -0.05, -0.05, 4, 0, 0, 40)
	if $head.global_position.distance_to(gv.player.position) < 48:
		player_is_grabbed = !player_is_grabbed


func _on_hitbox_has_been_hit():
	print("I'VE BEEN HIT")
	hit()
