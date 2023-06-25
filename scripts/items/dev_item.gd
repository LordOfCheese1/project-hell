extends "res://scripts/classes/item_class.gd"

var usage_enabled = false


func _ready():
	setup_item(Vector2(0, 0))

func _physics_process(_delta):
	item_update()
	if grabbed_entity != null && usage_enabled:
		grabbed_entity.velocity = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down")) * 400
	if usage_enabled:
		if Input.is_action_just_pressed("test"):
			gv.spawn_explosion(30, get_global_mouse_position(), load("res://textures/environment/decals/movement_graffiti.png"), -0.05, 5, -0.05, 0, 0, 100)


func _process(_delta):
	visible = is_grabbed


func _on_used():
	usage_enabled = !usage_enabled
