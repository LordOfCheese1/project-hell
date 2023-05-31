extends "res://scripts/classes/projectile_class.gd"


func _ready():
	velocity.x = transform.x.x * 200
	velocity.y = -80
	$Sprite2D.scale = Vector2(0.1, 0.1)


func _physics_process(delta):
	projectile_update(delta)
	velocity.y += 400 * delta
	velocity.x = lerp(velocity.x, 0.0, 0.02)
	
	
	if $Sprite2D.scale.x < 1:
		$Sprite2D.scale.x += 0.025
	$Sprite2D.scale.y = $Sprite2D.scale.x


func _on_attackbox_has_attacked():
	gv.spawn_explosion(8, global_position, load("res://textures/particles/poison.png"), -0.02, -0.02, 4, 0, -130, 50)
	call_deferred("free")


func _on_body_entered(body):
	if body.is_in_group("wall"):
		gv.spawn_explosion(8, global_position, load("res://textures/particles/poison.png"), -0.02, -0.02, 4, 0, -130, 50)
		call_deferred("free")
