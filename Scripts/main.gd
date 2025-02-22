extends Node2D
var restart_button

func restart_scene():
	get_tree().reload_current_scene()

# Called when the node enters the scene tree for the first time.
func _ready():
	restart_button = $HUD/Node/RestartButton
	restart_button.connect("button_up", restart_scene)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reset_level"):
		restart_scene()
