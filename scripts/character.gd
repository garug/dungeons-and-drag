extends Node2D

var dragging = false

func _process(delta: float) -> void:
	if dragging:
		print(position)

func _input(event):
	if dragging and event is InputEventMouseButton and event.pressed == false:
		dragging = false;

func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			dragging = true
