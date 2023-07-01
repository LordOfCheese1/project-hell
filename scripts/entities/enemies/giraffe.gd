extends "res://scripts/classes/entity_class.gd"

@export var points = 9


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
	$head.look_at(Vector2(gv.player.position.x, gv.player.position.y - 32))
	$head.rotation_degrees = lerp(prev_head_rot, $head.rotation_degrees, 0.05)
	if gv.player.position.x > to_global($head.position).x:
		$head.flip_v = false
	else:
		$head.flip_v = true
