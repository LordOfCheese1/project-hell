extends CanvasLayer

var visibility = 0.0


func _ready():
	$tentacles.modulate.a = 0


func _process(_delta):
	$blood_gradient.material.set_shader_parameter("vignette_opacity", visibility)
	if $tentacles.modulate.a < 0.02:
		$tentacles.visible = false
	else:
		$tentacles.visible = true
