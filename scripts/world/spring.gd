extends StaticBody2D

var surface_pos = 0.0
var bounce_amount = -400


func _physics_process(_delta):
	if surface_pos < 0:
		surface_pos += 1.0
	
	$surface.position.y = lerp($surface.position.y, surface_pos, 0.2)


func _on_entity_detector_body_entered(body):
	if body.is_in_group("entity"):
		if surface_pos == 0.0:
			surface_pos = -16
			body.velocity.y = bounce_amount
