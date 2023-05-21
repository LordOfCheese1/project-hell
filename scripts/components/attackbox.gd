extends Area2D

var ignore_in_detection = []
@export var damage : float
signal has_attacked


func _ready():
	add_to_group("attackbox")


func _on_area_entered(area):
	if area.is_in_group("hitbox"):
		if !ignore_in_detection.has(area.get_parent()):
			area.hit(damage)
			emit_signal("has_attacked")
