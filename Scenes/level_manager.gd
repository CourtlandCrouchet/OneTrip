extends Node2D

var cargo_locations: Array[Vector2]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_button_button_up() -> void:
	# get the cargo locations
	for child in $Stacking/Items.get_children():
		cargo_locations.append(child.position)
	
	# swap out the scenes
	remove_child($Stacking)
	var level_one = load("res://Scenes/main.tscn")
	var level_instance = level_one.instantiate()
	
	# spawn in cargo at locations
	for box_position in cargo_locations:
		var box = load("res://Scenes/box.tscn")
		var box_instance = box.instantiate()
		level_instance.get_node("Player/Arm/ItemPlacementMarker").add_child(box_instance)
		box_instance.position = box_position
		level_instance.get_node("Cargo").add_child(box_instance)
	
	add_child(level_instance)
