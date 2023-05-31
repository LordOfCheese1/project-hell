extends "res://scripts/classes/projectile_class.gd"


func _ready():
	velocity = transform.x * 220


func _physics_process(delta):
	projectile_update(delta)


func _on_body_entered(body):
	if body.get_class() == "TileMap":
		gv.spawn_explosion(12, global_position, load("res://textures/particles/fire1.png"), -0.05, 0, 4, 0, 0, 30)
		call_deferred("free")


func _on_attackbox_has_attacked():
	gv.spawn_explosion(12, global_position, load("res://textures/particles/fire1.png"), -0.05, 0, 4, 0, 0, 30)
	call_deferred("free")
