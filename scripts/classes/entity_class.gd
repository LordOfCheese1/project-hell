extends CharacterBody2D

var hp = 1.0
var gravity = 550
var grabbed_items = []
var max_grab = 0
var is_dead = false
var type = 0 #0 = friendly, 1 = enemy, 2 = boss


func setup_entity(starting_hp : float, grab_capacity : int, entity_type = 0):
	add_to_group("entity")
	hp = starting_hp
	max_grab = grab_capacity
	type = entity_type
