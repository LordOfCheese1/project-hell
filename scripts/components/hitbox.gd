extends Area2D

@export var entity : NodePath
signal hit


func _ready():
	add_to_group("hitbox")


func _on_area_entered(area):
	if area.is_in_group("attackbox"):
		emit_signal("hit")
