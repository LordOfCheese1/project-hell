extends "res://scripts/classes/projectile_class.gd"


func _ready():
	velocity = transform.x * 200


func _physics_process(delta):
	projectile_update(delta)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		call_deferred("free")
