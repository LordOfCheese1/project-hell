extends "res://scripts/classes/item_class.gd"


func _ready():
	setup_item(Vector2(5, 0))


func _physics_process(delta):
	item_update()
	
	if !is_grabbed && is_attached_to == null:
		rotation_degrees += 8


func _on_used():
	if grabbed_entity != null:
		grabbed_entity.velocity.x = transform.x.x * 600
		grabbed_entity.velocity.y = transform.x.y * 300
