extends Area2D

@export var param : String


func _ready():
	$CollisionShape2D.shape = null
	var square_shape = RectangleShape2D.new()
	square_shape.size = Vector2(16, 16)
	$CollisionShape2D.shape = square_shape


func _on_body_entered(body):
	if body.is_in_group("player"):
		mm.switch_level_param(param)
