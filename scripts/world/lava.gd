extends Area2D

const tile_size = 16.0
var dst_between_points = 2.0
var points = []
var point_velocities = []
var spring_power = 1
var next_update_value = Vector2()
@export var size = Vector2(1, 0)
@export var collider_size = Vector2(1, 1)


func _ready():
	var collider = RectangleShape2D.new()
	collider.size = collider_size * tile_size
	$CollisionShape2D.shape = collider
	$attackbox/CollisionShape2D.shape = collider
	$CollisionShape2D.position.x = (collider_size.x * tile_size) / 2
	$CollisionShape2D.position.y = -(collider_size.y * tile_size) / 2
	$attackbox/CollisionShape2D.position.x = (collider_size.x * tile_size) / 2
	$attackbox/CollisionShape2D.position.y = -(collider_size.y * tile_size) / 2
	$line.position.y = -16
	print($line.position.y)
	points = $lava_polygon.polygon
	if !Engine.is_editor_hint():
		create_points()
		refresh_points()


func _physics_process(delta):
	animate_points(delta)
	refresh_points()
	create_enter_waves()
	
	for i in range(len($line.points) - 1):
		$line.set_point_position(i, points[i + 2])


func create_points():
	points[0].x = size.x * tile_size
	points[2].y = size.y * tile_size
	
	#remove existing points
	for i in range(len(points) - 3):
		points.remove_at(i + 3)
	
	#create new points
	for i in range((tile_size / dst_between_points) * size.x):
		points.append(Vector2((i + 1) * dst_between_points, size.y * tile_size))
	
	#create velocities for new points
	for i in range(len(points) - 2):
		point_velocities.append(Vector2(0, 0))
		$line.add_point(points[i + 2])


func animate_points(delta):
	for i in range(len(point_velocities)):
		point_velocities[i].y += ((size.y * tile_size) - (points[i + 2].y)) * spring_power #snap point towards initial y pos
		
		if i + 1 < len(point_velocities): #snap towards point on your right
			point_velocities[i].y += ((points[i + 3].y) - (points[i + 2].y)) * spring_power
		
		if i - 1 > 0: #snap towards point on your left
			point_velocities[i].y += ((points[i + 1].y) - (points[i + 2].y)) * spring_power
		
		point_velocities[i].y *= 0.98
		
		points[i + 2] += point_velocities[i] * delta


func create_enter_waves():
	var point_index = 0
	if next_update_value != Vector2(0, 0):
		for i in points:
			if i.x == next_update_value.x:
				point_index = points.find(i)
		points[point_index].y += 12
		next_update_value = Vector2(0, 0)


func refresh_points():
	$lava_polygon.polygon = PackedVector2Array(points)


func _on_body_entered(body):
	if body.is_in_group("entity"):
		var enter_pos = Vector2()
		enter_pos.x = snapped(to_local(body.position).x, dst_between_points)
		enter_pos.x = clamp(enter_pos.x, points[2].x, points[len(points) - 1].x)
		enter_pos.y = 0.0
		next_update_value = enter_pos
		body.velocity.y = -220
