extends "res://scripts/classes/entity_class.gd"

@export var frequency : int
@export var starting_offset : int
var is_on_screen = false
var attack_cooldown = 0


func _ready():
	setup_entity(500, 1, 0)
	attack_cooldown = frequency


func _physics_process(_delta):
	if position.distance_to(gv.player.position) < 384:
		is_on_screen = true
	else:
		is_on_screen = false
	
	if starting_offset > 0:
		starting_offset -= 1
	else:
		if attack_cooldown > 0:
			attack_cooldown -= 1
		else:
			if is_on_screen:
				attack()
			attack_cooldown = frequency
	
	if len(grabbed_items) == 0:
		grab_item()
	else:
		grabbed_items[0].rotation_degrees = rotation_degrees
		grabbed_items[0].position = global_position + transform.x * 8
	
	$Sprite2D.scale = lerp($Sprite2D.scale, Vector2(1, 1), 0.1)
	
	entity_update()


func attack():
	$Sprite2D.scale = Vector2(1.3, 1.3)
	if len(grabbed_items) > 0:
		grabbed_items[0].use()


func grab_item():
	if $item_grab_area.items_in_range != [] && $item_grab_area.items_in_range[0].grabbed_entity == null:
		$item_grab_area.items_in_range[0].grab(self)
		$item_grab_area.refresh()
