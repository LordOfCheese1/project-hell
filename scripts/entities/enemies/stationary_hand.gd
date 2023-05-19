extends "res://scripts/classes/entity_class.gd"


func _ready():
	setup_entity(10.0, 1)


func _physics_process(delta):
	
	var prev_part : Node
	for i in $hand_parts.get_children():
		var prev_rot = i.rotation_degrees
		if prev_part != null:
			i.position = prev_part.transform.x * 28
			if gv.player != null:
				i.look_at(gv.player.position)
		else:
			i.look_at(Vector2(gv.player.position.x, gv.player.position.y - 64))
		i.rotation_degrees = lerp(prev_rot, i.rotation_degrees, 0.1)
		
		prev_part = i
	
	for i in grabbed_items:
		i.position = $hand_parts/upper_arm.global_position + $hand_parts/upper_arm.transform.x * 10
		if gv.player != null:
			i.look_at(gv.player.position)
	
	if grabbed_items == []:
		grab_item()


func grab_item():
	if $item_grab_area.items_in_range != []:
		$item_grab_area.items_in_range[0].grab(self)
		$item_grab_area.refresh()
