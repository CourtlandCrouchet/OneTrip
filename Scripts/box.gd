extends RigidBody2D

var broken_box = preload("res://Scenes/BrokenBox.tscn")
var already_scored = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Floor"):
		var instance = broken_box.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		queue_free()
