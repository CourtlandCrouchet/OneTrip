extends Area2D

var is_dragging = false #state management
var offset = Vector2(0,0)

signal increase_overlaps
signal decrease_overlaps

func _process(_delta):
	if is_dragging:
		followMouse()
		
func followMouse():
	position = get_global_mouse_position() + offset

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			offset = position - get_global_mouse_position()
			is_dragging = true
		else:
			is_dragging = false

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("StackItem"):
		increase_overlaps.emit()
	
func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("StackItem"):
		decrease_overlaps.emit()
