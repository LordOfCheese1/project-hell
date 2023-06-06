extends Area2D

@export var size : Vector2
@export var scene : String
@export var player_pos : Vector2


func _ready():
	$CollisionShape2D.shape = RectangleShape2D.new()
	$CollisionShape2D.shape.size = size


func _on_body_entered(body):
	if body.is_in_group("player"):
		sv.switch_scene(scene, player_pos)
