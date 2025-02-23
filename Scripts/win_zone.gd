extends Area2D

var box_count = 0
var end_level_timer = 3

func _ready() -> void:
	$Label.text = str(end_level_timer)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		$Timer.start()
	if body.is_in_group("Box") && !body.already_scored:
		box_count += 1
		body.already_scored = true

func _on_timer_timeout() -> void:
	end_level_timer -= 1
	$Label.text = str(end_level_timer)
	if end_level_timer <= -1:
		$Label.text = "Cargo Collected: " + str(box_count)
