extends Node2D

var total_item_count = 0
var items_stacked_count = 0

var items_overlapping = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_up_items(): 
	total_item_count = $Items.get_child_count()
	for child in $Items.get_children():
		child.connect("increase_overlaps", _box_overlap)
		child.connect("decrease_overlaps", _box_not_overlap)

func all_items_stacked() -> bool:
	return total_item_count == items_stacked_count

func _on_stack_zone_area_entered(area: Area2D) -> void:
	items_stacked_count += 1
	if all_items_stacked() and !items_overlapping:
		$StartButton.visible = true

func _on_stack_zone_area_exited(area: Area2D) -> void:
	$StartButton.visible = false
	items_stacked_count -= 1

func _box_overlap() -> void:
	$StartButton.visible = false
	items_overlapping += 1
	if all_items_stacked():
		$OverlapWarning.visible = items_overlapping

func _box_not_overlap() -> void:
	items_overlapping -= 1
	if all_items_stacked():
		$OverlapWarning.visible = items_overlapping
		$StartButton.visible = !items_overlapping
