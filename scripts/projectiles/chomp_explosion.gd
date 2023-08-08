extends "res://scripts/classes/projectile_class.gd"

var time = 0


func _ready():
	gv.spawn_explosion(24, global_position, load("res://textures/particles/tooth.png"), -0.05, 0, 4, 0, 0, 80)


func _physics_process(_delta):
	$attackbox/CollisionShape2D.scale = lerp($attackbox/CollisionShape2D.scale, Vector2(1, 1), 0.1)
	time += 1
	if time > 20:
		call_deferred("free")
