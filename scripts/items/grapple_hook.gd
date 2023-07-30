extends "res://scripts/classes/item_class.gd"

var attached_point = Vector2(0, 0)
var is_attached = false


func _ready():
	setup_item(Vector2(12, 0))


func _physics_process(delta):
	item_update()
	
	if grabbed_entity != null:
		
		if is_attached:
			grabbed_entity.velocity.x += Input.get_axis("left", "right") * 10
			grabbed_entity.velocity.y = clamp(grabbed_entity.velocity.y, -300, 300)
			$line.set_point_position(1, to_local(attached_point))
			grabbed_entity.position = lerp(grabbed_entity.position, attached_point, 0.1)
			$hit_indicator.position = to_local(attached_point)
		else:
			if $raycast.is_colliding():
				$hit_indicator.position = to_local($raycast.get_collision_point())
				$hit_indicator.visible = true
			else:
				$hit_indicator.visible = false


func _on_used():
	if $raycast.is_colliding():
		if !is_attached:
			attached_point = $raycast.get_collision_point()
		else:
			attached_point = to_global(Vector2(0, 0))
			if grabbed_entity != null:
				grabbed_entity.velocity.y = 0
		is_attached = !is_attached
		$line.set_point_position(1, to_local(attached_point))
	else:
		attached_point = to_global(Vector2(0, 0))
		if grabbed_entity != null:
			grabbed_entity.velocity.x = grabbed_entity.velocity.x * 2
		is_attached = false
		$line.set_point_position(1, to_local(attached_point))
