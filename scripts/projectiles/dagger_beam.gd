extends "res://scripts/classes/projectile_class.gd"


func _ready():
	velocity = transform.x * (230 + randi_range(-20, 20))


func _physics_process(delta):
	projectile_update(delta)
	velocity = lerp(velocity, Vector2(0, 0), 0.02)
	if abs(velocity.x) + abs(velocity.y) < 5:
		call_deferred("free")
	$Sprite2D.scale.x -= 0.05
	$Sprite2D.scale.y = $Sprite2D.scale.x
	if $Sprite2D.scale.x <= 0:
		call_deferred("free")


func _on_body_entered(body):
	if body.get_class() == "TileMap":
		call_deferred("free")
