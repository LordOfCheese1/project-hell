extends Line2D

var is_hooked = false
var hook_point = Vector2()
var default_pos = Vector2()


func _ready():
	default_pos = Vector2(-position.x * 3, position.y + 6)
	hook_point = get_parent().get_parent().global_position
	hook_point.y = hook_point.y + 6


func _physics_process(delta):
	if !is_hooked or !get_parent().get_parent().is_on_floor():# && get_parent().get_parent().is_on_floor():
		if get_parent().get_parent().is_on_floor():
			hook_point = Vector2(get_parent().get_parent().position.x, get_parent().get_parent().position.y + 10)
		else:
			hook_point.x = get_parent().get_parent().position.x + position.x * 2
			hook_point.y = get_parent().get_parent().position.y + position.y * 2
		is_hooked = true
	
	if is_hooked:# && get_parent().get_parent().is_on_floor():
		if hook_point.distance_to(to_global(default_pos)) > 10:
			is_hooked = false
	
	points[1] = to_local(hook_point)#lerp(points[1], to_local(hook_point), 0.2)
