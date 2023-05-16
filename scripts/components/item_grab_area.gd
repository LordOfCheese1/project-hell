extends Area2D

var items_in_range = []


func _on_area_entered(area):
	if area.is_in_group("item"):
		items_in_range.append(area)


func _on_area_exited(area):
	if items_in_range.has(area):
		items_in_range.remove_at(items_in_range.find(area))
