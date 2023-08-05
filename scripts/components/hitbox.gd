extends Area2D

@export var entity : NodePath
signal has_been_hit


func _ready():
	add_to_group("hitbox")


func hit(damage : float):
	emit_signal("has_been_hit")
	if get_node_or_null(entity) != null:
		get_node_or_null(entity).hp -= damage
