extends "res://scripts/classes/projectile_class.gd"

var random_rot_value = 0.0
var init_rot = 0.0


func _ready():
	randomize()
	random_rot_value = randf_range(-10, 10)
	init_rot = rotation_degrees


func _physics_process(delta):
	projectile_update(delta)
	rotation_degrees += random_rot_value
	velocity = lerp(velocity, Vector2(0, 0), 0.02)
	scale = lerp(scale, Vector2(0, 0), 0.02)
	if scale.x <= 0.1:
		call_deferred("free")


func _on_body_entered(body):
	if body.is_in_group("wall"):
		call_deferred("free")


func _on_attackbox_has_attacked():
	call_deferred("free")
