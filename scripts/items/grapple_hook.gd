extends "res://scripts/classes/item_class.gd"

var attached_point = Vector2(0, 0)
var is_attached = false
var line_pos = Vector2()
var velocity = Vector2()
var touching_wall = false


func _ready():
	setup_item(Vector2(8, 0))


func _physics_process(delta):
	item_update()
	
	position += velocity * delta
	
	if !touching_wall && grabbed_entity == null && is_attached_to == null:
		velocity.y += gravity_pull * delta
		rotation_degrees += velocity.y / 10
	else:
		velocity = Vector2(0, 0)
	
	velocity.x = lerp(velocity.x, 0.0, 0.01)
	
	if grabbed_entity != null:
		
		if is_attached:
			grabbed_entity.velocity.y = clamp(grabbed_entity.velocity.y, -300, 300)
			$line.set_point_position(1, to_local(attached_point))
			grabbed_entity.velocity += (attached_point - grabbed_entity.position) * 0.4
			$hit_indicator.position = to_local(attached_point)
		else:
			if $raycast.is_colliding():
				$hit_indicator.position = to_local($raycast.get_collision_point())
				$hit_indicator.visible = true
			else:
				$hit_indicator.visible = false
	else:
		is_attached = false
		line_pos = to_global(Vector2(0, 0))
		attached_point = to_global(Vector2(0, 0))
		$line.set_point_position(1, to_local(attached_point))
		$hit_indicator.visible = false


func _on_used():
	if $raycast.is_colliding():
		if !is_attached:
			attached_point = $raycast.get_collision_point()
		else:
			attached_point = to_global(Vector2(0, 0))
		is_attached = !is_attached
		$line.set_point_position(1, to_local(attached_point))
	else:
		attached_point = to_global(Vector2(0, 0))
		if grabbed_entity != null:
			grabbed_entity.velocity.x = grabbed_entity.velocity.x * 2
		is_attached = false
		$line.set_point_position(1, to_local(attached_point))


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y * 0.017
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false
