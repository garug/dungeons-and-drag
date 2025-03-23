extends CharacterBody2D

var dragging = false

var speed = 20

func _physics_process(delta: float) -> void:
	if !dragging:
		return
	var direction = get_global_mouse_position() - position
	velocity = direction * speed
	move_and_slide()

func _input(event):
	if dragging and event is InputEventMouseButton and event.pressed == false:
		dragging = false

func _on_touch_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed == true:
			dragging = true
