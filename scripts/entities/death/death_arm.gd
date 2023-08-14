extends Node2D

var target_pos = Vector2(0, 0)
var last_part_pos = Vector2(0, 0)


func _physics_process(delta):
	movements()


func movements():
	var prev_part = target_pos
	
	for i in get_child_count(): #Loop through segments
		get_child(i).look_at(prev_part) #Look at previous part
		get_child(i).position = prev_part - get_child(i).transform.x * 24 #put current point behind prev segment
		prev_part = get_child(i).position 
	
	var dst_to_move = get_child(get_child_count() - 1).position - Vector2(0, 0) #get distance from first segment to init(which is (0, 0)
	
	for i in get_children(): #Move all segments back by the distance calculated above
		i.position -= dst_to_move
	
	last_part_pos = get_child(get_child_count() - 1).position
