extends Node2D

var hacky_position_scaler = .125
var cargo_locations: Array[Vector2]

var box_scene = preload("res://Scenes/StackableItems/box.tscn")

var current_level = "LevelOne"

var level_cargo_sets = {
	"LevelOne": [box_scene, box_scene, box_scene],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_stacking("LevelOne")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level_stacking(level_name: String):
	print("Loading Level: ", level_name)
	if get_child_count() > 0 and get_children()[0].name == "Level":
		$Stacking.free
		remove_child($Level)
		
	var stacking_scene = load("res://Scenes/stacking.tscn")
	var stacking_instance = stacking_scene.instantiate()
	add_child(stacking_instance)
	
	var potential_item_spawns = $Stacking/Items.get_children()
	
	var i = 0
	for item in level_cargo_sets[level_name]:
		var item_instance = item.instantiate()
		potential_item_spawns[i].add_child(item_instance)
		item_instance.position = potential_item_spawns[i].position
		i += 1
		
	# remove spawn location markers
	for marker in $Stacking/Items.get_children():
		if marker.get_child_count() > 0:
			var item = marker.get_children()[0]
			print(item)
			marker.remove_child(item)
			marker.get_parent().add_child(item)
		$Stacking/Items.remove_child(marker)
		marker.free
	
	$Stacking.set_up_items()
	
	$Stacking/StartButton.connect("button_up", _on_start_button_button_up)

func _on_start_button_button_up() -> void:
	print("pressed go button!")
	# get the cargo locations
	for child in $Stacking/Items.get_children():
		cargo_locations.append(child.position)
	
	# swap out the scenes
	$Stacking.free
	remove_child($Stacking)
	var level_one = load("res://Scenes/main.tscn")
	var level_instance = level_one.instantiate()
	
	# spawn in cargo at locations
	for box_position in cargo_locations:
		var box = load("res://Scenes/box.tscn")
		var box_instance = box.instantiate()
		level_instance.get_node("Player/Arm/ItemPlacementMarker").add_child(box_instance)
		box_instance.position = box_position * hacky_position_scaler
		level_instance.get_node("Cargo").add_child(box_instance)
	
	add_child(level_instance)
