extends "res://scripts/classes/entity_class.gd"

var prev_pos = Vector2()
@export var length = 12
var spotted_target = false
var head_rot_dir = 6.0
var speed = 40.0
@export var starting_speed = 40.0
@export var chase_speed = 140.0
var colliders = []
var attack_cooldown = 0
var attackbox_enabled = 0


func _ready():
	setup_entity(25.0, 0, 1)
	create_points()
	$attackbox.ignore_in_detection.append(self)


func _physics_process(_delta):
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
	
	animate_body()
	
	if attack_cooldown > 0:
		attack_cooldown -= 1
	else:
		attack()
		attack_cooldown = 20
	
	if attackbox_enabled > 0:
		attackbox_enabled -= 1
	else:
		$attackbox/CollisionShape2D.disabled = true
	
	if hp <= 0:
		die(12)
		call_deferred("free")
	
	entity_update()


func create_points():
	for i in range(length):
		$line.add_point(Vector2(i * 6, 0))
		var collider = CollisionShape2D.new()
		add_child(collider)
		var shape = CircleShape2D.new()
		shape.radius = 2
		collider.shape = shape
		colliders.append(collider)


func animate_body():
	for i in range(len($line.points) - 1):
		$line.points[i + 1] += (prev_pos - position)
		if $line.points[i + 1].distance_to($line.points[i]) > 6:
			$line.points[i + 1] = lerp($line.points[i + 1], $line.points[i], 0.4)
		
		colliders[i + 1].position = $line.points[i + 1]


func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		spotted_target = true


func attack():
	$attackbox/CollisionShape2D.disabled = false
	gv.spawn_explosion(15, global_position, load("res://textures/particles/lighting_spark.png"), -0.05, 0, 20, 0, 0, 80)
	attackbox_enabled = 10


func _on_hitbox_has_been_hit():
	hit()
