extends "res://scripts/classes/entity_class.gd"

var prev_pos = Vector2()
@export var length = 12
var spotted_target = false
var head_rot_dir = 6.0
var speed = 40.0
@export var starting_speed = 40.0
@export var chase_speed = 140.0
var colliders = []


func _ready():
	setup_entity(25.0, 0, 1)
	create_points()


func _physics_process(delta):
	prev_pos = global_position
	move_and_slide()
	
	if gv.player == null:
		spotted_target = false
	
	#head movements
	var prev_head_rot = $head.rotation_degrees
	if !spotted_target:
		$head.rotation_degrees += head_rot_dir
		speed = lerp(speed, starting_speed, 0.1)
	else:
		speed = lerp(speed, chase_speed, 0.1)
		$head.look_at(gv.player.position)
	$head.rotation_degrees = lerp(prev_head_rot, $head.rotation_degrees, 0.1)
	
	velocity = lerp(velocity, $head.transform.x * speed, 0.1)
	
	animate_body(delta)


func create_points():
	for i in range(length):
		$line.add_point(Vector2(0, 0))
		var collider = CollisionShape2D.new()
		add_child(collider)
		var shape = CircleShape2D.new()
		shape.radius = 2
		collider.shape = shape
		colliders.append(collider)


func animate_body(delta : float):
	for i in range(len($line.points) - 1):
		$line.points[i + 1] += (prev_pos - position)
		if $line.points[i + 1].distance_to($line.points[i]) > 6:
			$line.points[i + 1] = lerp($line.points[i + 1], $line.points[i], 0.4)
		colliders[i + 1].position = $line.points[i + 1]


func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		spotted_target = true
