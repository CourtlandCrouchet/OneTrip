extends RigidBody2D
var explosion = preload("res://Scenes/explosion.tscn")
var already_scored = false

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Floor"):
		var instance = explosion.instantiate()
		instance.position = position
		get_parent().add_child(instance)
		queue_free()
