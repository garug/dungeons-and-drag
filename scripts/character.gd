extends CharacterBody2D

class_name Character

var dragging = false

var speed = 20

var current_path = []

func _physics_process(delta: float) -> void:
	if dragging:
		_move()
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed == true:
		_on_move_start()

func _input(event: InputEvent):
	if dragging and event is InputEventMouseButton and event.pressed == false:
		_on_move_end()

func _move():
	velocity = get_local_mouse_position() * speed
	move_and_slide()
	
func _on_move_start():
	$SwapArea.monitoring = true
	$SwapArea.set_collision_layer_value(3, false)
	dragging = true

func _on_move_end():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	var final_position = snapped(position, Vector2.ONE * 64)
	tween.tween_property(self, "position", final_position, 0.05)
	await tween.finished
	dragging = false
	$SwapArea.monitoring = false
	$SwapArea.set_collision_layer_value(3, true)
	current_path = []

func _on_swap_area_area_entered(area: Area2D) -> void:
	var tile = area.get_parent()
	current_path.append(tile)
	await get_tree().process_frame
	if tile.inside != null:
		print("has content")
	#print(current_path)
