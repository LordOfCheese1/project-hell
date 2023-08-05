extends CharacterBody2D

var wanted_positions = [Vector2(2, 0), Vector2(-2, 0), Vector2(3, 0), Vector2(-4, 0)]
var init_pos = Vector2(0, 128)


func _physics_process(delta):
	for i in $legs.get_child_count():
		$legs.get_child(i).target_pos = lerp($legs.get_child(i).target_pos, get_global_mouse_position(), 0.1)
		if $legs.get_child(i).last_part_pos.y < init_pos.y:
			move_leg_back(i)
		if $legs.get_child(i).last_part_pos.distance_to(init_pos) > 64:
			move_leg_back(i)


func move_leg_back(idx : int):
	$legs.get_child(idx).target_pos = init_pos
