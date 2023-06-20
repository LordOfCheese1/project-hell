extends "res://scripts/classes/entity_class.gd"

var shader_fac = 0.0
var explode_cooldown = 50
var max_explode_cooldown = 350
var target_leg_rot = 0.0


func _ready():
	setup_entity(5, 0, 1)


func _physics_process(delta):
	move_and_slide()
	
	
	if explode_cooldown > 0:
		explode_cooldown -= 1
	else:
		explode()
		explode_cooldown = max_explode_cooldown
	
	shader_fac = lerp(shader_fac, 0.0, 0.1)
	$body.material.set_shader_parameter("fac", shader_fac)
	$body.rotation_degrees += velocity.x * 0.4
	
	$leg/lower_leg.rotation_degrees = lerp($leg/lower_leg.rotation_degrees, randf_range(0, -60), 0.1)
	$leg/upper_leg.position = $leg/lower_leg.transform.x * 6
	$leg/upper_leg.rotation_degrees = -$leg/lower_leg.rotation_degrees
	
	entity_update()


func explode():
	pass


func _on_timer_timeout():
	if explode_cooldown < 100:
		shader_fac = 1.0
