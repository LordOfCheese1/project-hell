extends "res://scripts/classes/projectile_class.gd"


func _ready():
	velocity = transform.x * 220


func _physics_process(delta):
	projectile_update(delta)


func _on_body_entered(body):
	call_deferred("free")


func _on_attackbox_has_attacked():
	call_deferred("free")
