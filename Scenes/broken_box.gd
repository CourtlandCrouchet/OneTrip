extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.start()

func _on_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.parallel().tween_property($RigidBody2D2/Sprite2D, "modulate:a", 0, 1)
	tween.parallel().tween_property($RigidBody2D/Sprite2D, "modulate:a", 0, 1)
