extends "res://scripts/classes/projectile_class.gd"


var laser_length = 0.0
var did_laser_once = false
var collider_shape = RectangleShape2D.new()


func _ready():
	$attackbox/CollisionShape2D.shape = collider_shape
	collider_shape.size.y = 4


func _physics_process(delta):
	projectile_update(delta)
	if !did_laser_once:
		laser_length = to_local($wall_detect.get_collision_point()).x
		if laser_length > 0:
			$attackbox/CollisionShape2D.position.x = laser_length / 2
			$attackbox/CollisionShape2D.shape.size.x = laser_length
		$visuals.points[1].x = laser_length
		did_laser_once = true
	
	if $visuals.width < 1:
		$attackbox/CollisionShape2D.disabled = true
	
	$visuals.width = lerp($visuals.width, 0.0, 0.15)
	
	$visuals.default_color = lerp($visuals.default_color, Color("b3343e"), 0.15)
	
	if $visuals.width <= 0.1:
		call_deferred("free")
