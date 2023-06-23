extends "res://scripts/classes/entity_class.gd"

var spotted_player = false
var desired_x_velocity = 0.0
var is_lasering = false
var laser_path = load("res://prefabs/projectiles/cerberus_laser.tscn")
var poison_path = load("res://prefabs/projectiles/poison_spew.tscn")
var laser_attack_cooldown = 120
var laser_spawn_cooldown = 0
var laser_head_rot_dir = 0
var poison_cooldown = 200
var orig_laser_head_rot = 0
#fmod stuffs


func _ready():
	setup_entity(22, 0, 2)
	$body/head_1/screw/particle_spawner.is_emitting = false


func _physics_process(delta):
	move_and_slide()
	velocity.y += gravity * delta
	if spotted_player:
		velocity.x = lerp(velocity.x, float(desired_x_velocity), 0.05)
		
		if position.distance_to(gv.player.position) > 80 && !is_lasering:
			desired_x_velocity = gv.player.position.x - position.x
		elif is_lasering:
			desired_x_velocity = 0.0
		else:
			desired_x_velocity = (position.x - gv.player.position.x) * 1.5
		
		
		if laser_attack_cooldown > 0:
			laser_attack_cooldown -= 1
		else:
			if is_lasering:
				end_laser()
			else:
				start_laser()
		if is_lasering:
			$body/head_0.desired_head_rot = orig_laser_head_rot - laser_attack_cooldown * laser_head_rot_dir
			if laser_spawn_cooldown > 0:
				laser_spawn_cooldown -= 1
			else:
				spawn_laser()
			$body/head_1.is_doing_something = false
		else:
			$body/head_1.is_doing_something = true
			$looker.look_at(Vector2(gv.player.position.x, gv.player.position.y - 80))
			$body/head_1.desired_head_rot = $looker.rotation_degrees
			if poison_cooldown > 0:
				poison_cooldown -= 1
			else:
				spawn_poison()
			$body/head_1/screw/particle_spawner.freq = poison_cooldown * delta
		
		$body/head_1/screw/particle_spawner.is_emitting = !is_lasering
	
	$body.rotation_degrees = velocity.x / 5
	
	$body/leg_left.rotation_degrees = lerp($body/leg_left.rotation_degrees, -$body.rotation_degrees * 2, 0.15)
	$body/leg_right.rotation_degrees = lerp($body/leg_right.rotation_degrees, -$body.rotation_degrees * 2, 0.15)
	
	entity_update()


func _process(_delta):
	if hp <= 0.0 && !is_dead:
		die(9)
		is_dead = true
		grabbed_items = []
		mm.switch_boss_param("Victory")
		call_deferred("free")
		#mm.switch_fmod_event("LVL1") #need to wait 3 seconds before executing
	
	if !spotted_player && position.distance_to(gv.player.position) < 128:
		spot_player()


func start_laser():
	orig_laser_head_rot = $body/head_0/screw.rotation_degrees
	laser_spawn_cooldown = 10
	laser_attack_cooldown = 140
	$body/head_0.is_doing_something = true
	is_lasering = true


func end_laser():
	is_lasering = false
	laser_attack_cooldown = 360
	$body/head_0.is_doing_something = false


func spawn_laser():
	laser_head_rot_dir = ((gv.player.position.x - position.x) / abs(gv.player.position.x - position.x))
	laser_spawn_cooldown = 5
	var laser_inst = laser_path.instantiate()
	laser_inst.rotation_degrees = $body/head_0/screw.rotation_degrees
	laser_inst.global_position = $body/head_0/screw.global_position
	laser_inst.get_child(0).ignore_in_detection.append(self)
	get_tree().current_scene.add_child(laser_inst)


func spawn_poison():
	poison_cooldown = 90
	var poison_inst = poison_path.instantiate()
	poison_inst.rotation_degrees = $body/head_1/screw.rotation_degrees
	poison_inst.global_position = $body/head_1/screw.global_position + $body/head_1/screw.transform.x * 8
	poison_inst.get_child(0).ignore_in_detection.append(self)
	get_tree().current_scene.add_child(poison_inst)


func spot_player():
	spotted_player = true
	mm.switch_fmod_event("LVL1Boss")


func _on_hitbox_has_been_hit():
	hit()
	if !spotted_player:
		spot_player()
