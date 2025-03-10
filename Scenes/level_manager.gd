extends Node2D

var hacky_position_scaler = .085
var cargo_locations: Array[Array]

var box_scene: PackedScene = preload("res://Scenes/StackableItems/box.tscn")
var gear_scene: PackedScene = preload("res://Scenes/StackableItems/gear.tscn")
var cheese_scene: PackedScene = preload("res://Scenes/StackableItems/cheese.tscn")
var birdcage_scene: PackedScene = preload("res://Scenes/StackableItems/birdcage.tscn")
var saxophone_scene: PackedScene = preload("res://Scenes/StackableItems/saxophone.tscn")

var current_level = "LevelThree"

var level_cargo_sets = {
	"LevelOne": [box_scene, box_scene, box_scene],
	"LevelTwo": [box_scene, box_scene, gear_scene, gear_scene, gear_scene],
	"LevelThree": [box_scene, box_scene, cheese_scene, cheese_scene, birdcage_scene],
	"LevelFour": [box_scene, box_scene, gear_scene, gear_scene, saxophone_scene],
	"LevelFive": [box_scene, box_scene, box_scene],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_level_select()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func load_level_stacking(level_name: String):
	if get_child_count() > 0 and get_children()[0].name == "Level":
		$Level.free
		remove_child($Level)
		
	var stacking_scene = load("res://Scenes/stacking.tscn")
	var stacking_instance = stacking_scene.instantiate()
	add_child(stacking_instance)
	
	var potential_item_spawns = $Stacking/Locations.get_children()
	
	var i = 0
	for item in level_cargo_sets[level_name]:
		var item_instance = item.instantiate()
		$Stacking/Items.add_child(item_instance)
		item_instance.global_position = potential_item_spawns[i].global_position
		i += 1
	
	$Stacking.set_up_items()
	
	$Stacking/StartButton.connect("button_up", _on_start_button_button_up)

func _on_start_button_button_up() -> void:
	# get the cargo locations
	for child in $Stacking/Items.get_children():
		print("item name: ", child.cargo_type)
		cargo_locations.append([child.cargo_type, child.position])
	
	# swap out the scenes
	$Stacking.free
	remove_child($Stacking)
	
	load_level_terrain()

func load_level_terrain():
	var level = ""
	
	match current_level:
		"LevelOne":
			level = load("res://Scenes/Levels/level_1.tscn")
		"LevelTwo":
			level = load("res://Scenes/Levels/level_2.tscn")
		"LevelThree":
			level = load("res://Scenes/Levels/level_3.tscn")
		"LevelFour":
			level = load("res://Scenes/Levels/level_4.tscn")
		"LevelFive":
			level = load("res://Scenes/Levels/level_5.tscn")
	
	var level_instance = level.instantiate()
	
	# spawn in cargo at locations
	for item in cargo_locations:
		var item_scene 
		
		print(item[0])
		
		match item[0]:
			"Box":
				item_scene = load("res://Scenes/box.tscn")
			"Gear":
				item_scene = load("res://Scenes/gear.tscn")
			"Cheese":
				item_scene = load("res://Scenes/cheese.tscn")
			"Birdcage":
				item_scene = load("res://Scenes/bird_cage.tscn")
			"Saxophone":
				item_scene = load("res://Scenes/saxophone.tscn")
				
		if item_scene:
			var box_instance = item_scene.instantiate()
			level_instance.get_node("Player/Arm/ItemPlacementMarker").add_child(box_instance)
			box_instance.position = item[1] * hacky_position_scaler
			#level_instance.get_node("BoxController").add_child(box_instance)
			box_instance.reparent(level_instance.get_node("BoxController"))
	
	add_child(level_instance)
	
	$Level/HUD/Node/LevelSelectorRedirect.connect("button_up", load_level_select)
	$Level/HUD/Node/RestartButton.connect("button_up", reload_level)
	$Level/HUD/Node/RestackButton.connect("button_up", return_to_stacking)

func load_level_select():
	cargo_locations = []
	# unload whatever scene might already be loaded
	if get_child_count() > 0 and get_children()[0].name == "Level":
		$Level.free
		remove_child($Level)
	if get_child_count() > 0 and get_children()[0].name == "Stacking":
		$Stacking.free
		remove_child($Stacking)

	# load in level select
	var level_select_scene = load("res://Scenes/level_selector.tscn")
	var level_select_instance = level_select_scene.instantiate()
	add_child(level_select_instance)
	
	var i = 1
	for button in $LevelSelector/LevelButtons.get_children():
		button.connect("button_up", load_level_wrapper.bind(i))
		i += 1

func load_level_wrapper(scene_number: int):
	$LevelSelector.free
	remove_child($LevelSelector)
	
	match scene_number:
		1:
			current_level = "LevelOne"
		2:
			current_level = "LevelTwo"
		3:
			current_level = "LevelThree"
		4:
			current_level = "LevelFour"
		5:
			current_level = "LevelFive"
			
	cargo_locations = []
	load_level_stacking(current_level)

func return_to_stacking():
	cargo_locations = []
	$Level.free
	remove_child($Level)
	load_level_stacking(current_level)

func reload_level():
	$Level.free
	remove_child($Level)
	load_level_terrain()
