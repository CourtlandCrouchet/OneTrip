extends Node2D

@export var target_node: Node2D = null

func _process(_delta) -> void:
	if target_node:
		position = target_node.global_position
