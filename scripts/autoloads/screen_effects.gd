extends CanvasLayer

var visibility = 0.0

func _process(delta):
	$blood_gradient.material.set_shader_parameter("vignette_opacity", visibility)
