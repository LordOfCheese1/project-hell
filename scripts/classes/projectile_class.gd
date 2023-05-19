extends Area2D

var velocity = Vector2()


func projectile_update(delta):
	position += velocity * delta
