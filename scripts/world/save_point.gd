extends Area2D

var new_gear_rot = 0.0
var scrap_path = load("res://prefabs/world/scrap.tscn")


func _physics_process(_delta):
	new_gear_rot += 1.5
	
	if $gear.rotation_degrees >= 360:
		$gear.rotation_degrees = 0
		new_gear_rot = 0.0
	
	$gear.rotation_degrees = lerp($gear.rotation_degrees, new_gear_rot, 0.1)
	$finger_left.rotation_degrees = lerp($finger_left.rotation_degrees, 0.0, 0.1)
	$finger_right.rotation_degrees = lerp($finger_right.rotation_degrees, 0.0, 0.1)
	
	$colour.color = lerp($colour.color, Color("b3343e"), 0.05)


func _on_body_entered(body):
	if body.is_in_group("player"):
		new_gear_rot -= 180
		$colour.color = Color("f5ea84")
		sv.save_values(true)
		$finger_left.rotation_degrees = -30
		$finger_right.rotation_degrees = 30
		gv.player.hp = gv.player.max_hp
