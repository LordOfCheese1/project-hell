extends "res://scripts/classes/entity_class.gd"

var shader_fac = 0.0
var explode_cooldown = 300
var max_explode_cooldown = 300
var target_leg_rot = 0.0
var leg_change_time = 0.0
var jump_velocity = -100
var explosion_path = load("res://prefabs/projectiles/laser.tscn")
var spotted_player = false


func _ready():
	setup_entity(5, 0, 1)


func _physics_process(delta):
	move_and_slide()
	
	if spotted_player:
		if gv.player != null:
			velocity.x = clamp(gv.player.position.x - position.x, -100, 100)
		if velocity.y < gravity:
			velocity.y += gravity * delta
		
		if explode_cooldown > 0:
			explode_cooldown -= 1
		else:
			explode()
			explode_cooldown = max_explode_cooldown
		
		if is_on_floor():
			if randi_range(0, 12) == 0:
				velocity.y = jump_velocity
		
		shader_fac = lerp(shader_fac, 0.0, 0.1)
		$body.material.set_shader_parameter("fac", shader_fac)
		$body.rotation_degrees = velocity.x * 0.4
		
		$leg/lower_leg.rotation_degrees = lerp($leg/lower_leg.rotation_degrees, target_leg_rot, 0.1)
		$leg/upper_leg.position = $leg/lower_leg.transform.x * 6
		$leg/upper_leg.rotation_degrees = -$leg/lower_leg.rotation_degrees
		$leg.scale.x = lerp($leg.scale.x, velocity.x / abs(velocity.x), 0.1)
		
		leg_change_time += delta
		if leg_change_time > 0.3:
			leg_change_time = 0.0
			if target_leg_rot != 0.0:
				target_leg_rot = 0.0
			else:
				target_leg_rot = -60.0
	elif gv.player != null:
		if position.distance_to(gv.player.position) < 256:
			spotted_player = true
	
	entity_update()


func explode():
	for i in range(15):
		var explosion_inst = explosion_path.instantiate()
		explosion_inst.get_child(0).ignore_in_detection.append(self)
		explosion_inst.position.x = position.x + randf_range(-4, 4)
		explosion_inst.position.y = position.y + randf_range(-4, 4)
		explosion_inst.rotation_degrees = randi_range(0, 360)
		get_tree().current_scene.add_child(explosion_inst)


func _on_timer_timeout():
	if explode_cooldown < 100:
		shader_fac = 1.0


func _on_hitbox_has_been_hit():
	hit()
