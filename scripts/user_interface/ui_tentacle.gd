extends Node2D

var point_velocities = []
var length = 16
var stretch_limit = 4.0
var crawl_progress = 0
var orig_pos = Vector2()


func _ready():
	orig_pos = global_position
	randomize()
	stretch_limit = randf_range(4, 8)
	length = randi_range(16, 32)
	for i in range(length):
		$line.add_point(Vector2(i * 4, randi_range(-4, 4)))
	
	for i in range(len($line.points) - 1):
		point_velocities.append(Vector2(0, 0.05))
	
	look_at(get_parent().position + Vector2(192.0, 128.0))


func _physics_process(_delta):
	visible = get_parent().visible
	if visible:
		crawl_progress = get_parent().modulate.a
		position = orig_pos + (-transform.x * 64 + transform.x * (crawl_progress * 64))
		for i in range(len($line.points) - 1):
			if abs($line.points[i + 1].y) > stretch_limit:
				point_velocities[i].y *= -1
			$line.set_point_position(i + 1, $line.points[i + 1] + point_velocities[i] * (i + 1))
