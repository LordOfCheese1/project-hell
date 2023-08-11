extends CanvasLayer


func _ready():
	$interface.visible = false


func _process(delta):
	if Input.is_action_just_pressed("debug"):
		toggle()
	
	if $interface.visible:
		$interface/frames_per_second.text = "FPS: " + str(Engine.get_frames_per_second())
		if gv.player != null:
			$interface/coords_x.text = "COORDS-X: " + str(snapped(gv.player.position.x, 1))
			$interface/coords_y.text = "COORDS-Y: " + str(snapped(gv.player.position.y, 1))
			$interface/hp.text = "HP: " + str(gv.player.hp)


func toggle():
	$interface.visible = !$interface.visible
