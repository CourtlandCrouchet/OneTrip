extends Node2D

var total_item_count = 0
var items_stacked_count = 0

var items_overlapping = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	total_item_count = $Items.get_child_count()

func all_items_stacked() -> bool:
	return total_item_count == items_stacked_count

func _on_stack_zone_area_entered(area: Area2D) -> void:
	items_stacked_count += 1
	if all_items_stacked() and !items_overlapping:
		print("All done! Proceed to level!")

func _on_stack_zone_area_exited(area: Area2D) -> void:
	items_stacked_count -= 1

func box_overlap() -> void:
	items_overlapping += 1
	if all_items_stacked():
		$OverlapWarning.visible = items_overlapping

func box_not_overlap() -> void:
	items_overlapping -= 1
	if all_items_stacked():
		$OverlapWarning.visible = items_overlapping
	if all_items_stacked() and !items_overlapping:
		print("All done! Proceed to level!")
