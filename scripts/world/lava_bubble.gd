extends "res://scripts/classes/entity_class.gd"

var did_pop = false

@export var decay_time = 80
var textures = [
	load("res://textures/particles/lavabubble_small.png"),
	load("res://textures/particles/lavabubble_medium.png"),
	load("res://textures/particles/lavabubble_big.png")
]


func _ready():
	weight = randi_range(2, 4)
	add_to_group("bubble")
	setup_entity(1.5, 0, 0)
	$Sprite2D.scale = Vector2(0,0)
	$Sprite2D.texture = textures[randi_range(0, 2)]


func _physics_process(delta):
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(1, 1), 0.1)
	decay_time -= 1
	if decay_time > 0:
		position.y -= 0.2
	elif decay_time == 0:
		did_pop = true
		$CollisionShape2D.disabled = false
	elif decay_time <= 10:
		call_deferred("free")
	
	entity_update()
