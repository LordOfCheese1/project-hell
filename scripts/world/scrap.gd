extends Area2D

var velocity = Vector2(0, 0)


func _ready():
	velocity.y = randf_range(-50, -200)
	velocity.x = randf_range(-200, 200)


func _physics_process(delta):
	position += velocity * delta
	
	$Sprite2D.rotation_degrees += (abs(velocity.x) + abs(velocity.y)) / 10
	
	velocity.y += 550 * delta
	
	if position.distance_to(gv.player.position) < 48:
		velocity += (gv.player.position - position) * 0.5


func _on_body_entered(body):
	if body.is_in_group("wall") && velocity.y > 0:
		velocity.y = velocity.y * -0.85
		velocity.x = velocity.x * -0.85
	
	if body.is_in_group("player"):
		body.scrap += 1
		call_deferred("free")


func _on_visible_on_screen_enabler_2d_screen_exited():
	call_deferred("free")
