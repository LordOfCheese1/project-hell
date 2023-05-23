extends CharacterBody2D

var hp = 1.0
var gravity = 550
var grabbed_items = []
var max_grab = 0
var is_dead = false


func setup_entity(starting_hp : float, grab_capacity : int):
	add_to_group("entity")
	hp = starting_hp
	max_grab = grab_capacity
