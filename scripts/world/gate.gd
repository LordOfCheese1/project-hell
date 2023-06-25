extends StaticBody2D

@export var size : int #amount of blocks, each one is 16 in height
@export var entity_to_defeat : NodePath
var block_texture = load("res://textures/environment/gate/block.png")
var should_open = false


func _ready():
	for i in range(size):
		var block_inst = Sprite2D.new()
		block_inst.texture = block_texture
		block_inst.position.x = 0
		block_inst.position.y = (float(i) - (float(size) / 2.0)) * 16 + 8
		$blocks.call_deferred("add_child", block_inst)
	$scaffolding.scale.y = size
	$CollisionShape2D.shape.size.y = size * 16


func _process(_delta):
	if get_node_or_null(entity_to_defeat) == null && !should_open:
		should_open = true


func _physics_process(_delta):
	if should_open:
		if len($blocks.get_children()) > 0:
			if $blocks.get_child(0).scale.x > 0.0:
				$blocks.get_child(0).scale -= Vector2(0.1, 0.1)
			else:
				$blocks.get_child(0).call_deferred("free")
		$scaffolding.scale.y = lerp($scaffolding.scale.y, 0.0, 0.1)
		if $blocks.get_child_count() == 0:
			call_deferred("free")
