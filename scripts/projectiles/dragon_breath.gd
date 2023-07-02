extends "res://scripts/classes/projectile_class.gd"

var death_timer = 60


func _ready():
	velocity = transform.x * 200
	scale = Vector2(0, 0)


func _physics_process(delta):
	velocity = lerp(velocity, Vector2(0, 0), 0.03)
	scale = lerp(scale, Vector2(1, 1), 0.05)
	modulate.a = lerp(modulate.a, 0.0, 0.03)
	
	if death_timer > 0:
		death_timer -= 1
	else:
		call_deferred("free")
	
	projectile_update(delta)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		call_deferred("free")
