extends "res://scripts/classes/projectile_class.gd"


var laser_length = 0.0


func _physics_process(delta):
	projectile_update(delta)
	laser_length = to_local($wall_detect.get_collision_point()).x
	if laser_length > 0:
		$attackbox/CollisionShape2D.shape.size.x = laser_length
	$attackbox/CollisionShape2D.position.x = laser_length / 2
	$visuals.points[1].x = laser_length
	$visuals.width = lerp($visuals.width, 0.0, 0.15)
	
	$visuals.default_color = lerp($visuals.default_color, Color("b3343e"), 0.15)
	
	if $visuals.width <= 0.1:
		call_deferred("free")
