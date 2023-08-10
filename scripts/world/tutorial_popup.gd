extends Area2D

var player_in_range = false
@export var size = Vector2(1, 1)


func _ready():
	get_child(1).scale = Vector2(0.0, 0.0)
	get_child(1).modulate.a = 0.0
	$CollisionShape2D.scale = size


func _physics_process(delta):
	if player_in_range:
		get_child(1).scale = lerp(get_child(1).scale, Vector2(1, 1), 0.1)
		get_child(1).modulate.a = lerp(get_child(1).modulate.a, 1.0, 0.15)
	else:
		get_child(1).scale = lerp(get_child(1).scale, Vector2(0, 0), 0.1)
		get_child(1).modulate.a = lerp(get_child(1).modulate.a, 0.0, 0.1)


func _on_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true


func _on_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
