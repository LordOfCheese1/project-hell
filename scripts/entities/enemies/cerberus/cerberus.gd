extends "res://scripts/classes/entity_class.gd"


var spotted_player = false
var desired_x_velocity = 0.0
var is_lasering = false
var laser_path = load("res://prefabs/projectiles/cerberus_laser.tscn")
var laser_attack_cooldown = 60
var laser_spawn_cooldown = 0
var orig_laser_head_rot = 0


func _ready():
	setup_entity(22, 0)


func _physics_process(delta):
	move_and_slide()
	velocity.y += gravity * delta
	if spotted_player:
		velocity.x = lerp(velocity.x, float(desired_x_velocity), 0.05)
		
		if position.distance_to(gv.player.position) > 80 && !is_lasering:
			desired_x_velocity = gv.player.position.x - position.x
		else:
			desired_x_velocity = 0.0
		
		
		if laser_attack_cooldown > 0:
			laser_attack_cooldown -= 1
		else:
			if is_lasering:
				end_laser()
			else:
				start_laser()
		if is_lasering:
			$body/head_0.desired_head_rot = orig_laser_head_rot - laser_attack_cooldown * ((gv.player.position.x - position.x) / abs(gv.player.position.x - position.x))
			if laser_spawn_cooldown > 0:
				laser_spawn_cooldown -= 1
			else:
				spawn_laser()
	
	$body.rotation_degrees = velocity.x / 5
	
	$body/leg_left.rotation_degrees = lerp($body/leg_left.rotation_degrees, -$body.rotation_degrees * 2, 0.15)
	$body/leg_right.rotation_degrees = lerp($body/leg_right.rotation_degrees, -$body.rotation_degrees * 2, 0.15)


func _process(_delta):
	if !spotted_player && position.distance_to(gv.player.position) < 128:
		spotted_player = true


func start_laser():
	orig_laser_head_rot = $body/head_0/screw.rotation_degrees
	laser_spawn_cooldown = 5
	laser_attack_cooldown = 140
	$body/head_0.is_doing_something = true
	is_lasering = true


func end_laser():
	is_lasering = false
	laser_attack_cooldown = 360
	$body/head_0.is_doing_something = false


func spawn_laser():
	laser_spawn_cooldown = 2
	var laser_inst = laser_path.instantiate()
	laser_inst.global_position = $body/head_0/screw.global_position
	laser_inst.rotation_degrees = $body/head_0/screw.rotation_degrees
	get_tree().current_scene.add_child(laser_inst)
