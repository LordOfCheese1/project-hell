extends "res://scripts/classes/item_class.gd"

var prev_entity_pos = []
var is_currently_using = false
var active_cooldown = 0


func _ready():
	setup_item()


func _physics_process(delta):
	item_update()
	
	if grabbed_entity != null && !is_currently_using:
		prev_entity_pos.append(grabbed_entity.position)
	
	if len(prev_entity_pos) > 6000:
		prev_entity_pos.remove_at(0)
	
	if is_currently_using:
		if grabbed_entity != null:
			grabbed_entity.velocity = Vector2(0, 0)
		if active_cooldown <= len(prev_entity_pos):
			if grabbed_entity != null && active_cooldown > 0:
				grabbed_entity.position = prev_entity_pos[active_cooldown]
			prev_entity_pos.remove_at(active_cooldown)
		if active_cooldown > 0:
			active_cooldown -= 1
		else:
			is_currently_using = false


func _on_used():
	if !is_currently_using:
		is_currently_using = true
		active_cooldown = len(prev_entity_pos) - 1
