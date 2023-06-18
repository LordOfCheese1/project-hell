extends "res://scripts/classes/item_class.gd"

var target_angle = 45.0


func _ready():
	setup_item(Vector2(6, 0))


func _physics_process(delta):
	item_update()
	
	$upper_blade.rotation_degrees = lerp($upper_blade.rotation_degrees, float(-target_angle), 0.3)
	$lower_blade.rotation_degrees = lerp($lower_blade.rotation_degrees, float(target_angle), 0.3)
	
	if $lower_blade.rotation_degrees < 4:
		target_angle = 45


func _on_used():
	target_angle = 0
