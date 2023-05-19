extends "res://scripts/classes/item_class.gd"

func _ready():
	setup_item(Vector2(0, 0))


func _physics_process(delta):
	item_update()


func _on_used():
	pass
