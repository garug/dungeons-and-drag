extends CharacterBody2D

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
	var current_local = snapped(global_position, Vector2.ONE * 64)
	if(current_path.back() != current_local):
		current_path.append(current_local)
		print(current_path)
	move_and_slide()
	
func _on_move_start():
	$SwapArea.monitoring = false
	current_path.append(snapped(global_position, Vector2.ONE * 64))
	dragging = true

func _on_move_end():
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	var final_position = snapped(position, Vector2.ONE * 64)
	tween.tween_property(self, "position", final_position, 0.05)
	await tween.finished
	dragging = false
	current_path = []
	$SwapArea.monitoring = true

func _on_swap_area_area_entered(area: Area2D) -> void:
	var last_tile = area.get_parent().current_path.back()
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "global_position", last_tile, 0.05)
	await tween.finished
