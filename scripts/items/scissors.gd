extends "res://scripts/classes/item_class.gd"

var target_angle = 45.0
var velocity = Vector2()
var touching_wall = false


func _ready():
	setup_item(Vector2(6, 0))


func _physics_process(delta):
	item_update()
	
	$upper_blade.rotation_degrees = lerp($upper_blade.rotation_degrees, float(-target_angle), 0.3)
	$lower_blade.rotation_degrees = lerp($lower_blade.rotation_degrees, float(target_angle), 0.3)
	
	if $lower_blade.rotation_degrees < 4:
		target_angle = 45
		$attackbox/CollisionShape2D.disabled = true
	
	position += velocity * delta
	if !touching_wall && is_attached_to == null && grabbed_entity == null:
		velocity.y += 550 * delta
		rotation_degrees += velocity.y * 0.05
	else:
		velocity = Vector2(0, 0)
	
	if grabbed_entity != null:
		if len($attackbox.ignore_in_detection) > 0:
			$attackbox.ignore_in_detection[0] = grabbed_entity
		else:
			$attackbox.ignore_in_detection.append(null)

func _on_used():
	target_angle = 0
	$attackbox/CollisionShape2D.disabled = false


func _on_grabbed():
	$attackbox.ignore_in_detection.clear()
	$attackbox.ignore_in_detection.append(grabbed_entity)


func _on_body_entered(body):
	if body.is_in_group("wall"):
		position.y -= velocity.y * 0.017
		touching_wall = true


func _on_body_exited(body):
	if body.is_in_group("wall"):
		touching_wall = false
