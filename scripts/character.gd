extends CharacterBody2D

class_name PlayableCharacter

var dragging = false

var max_speed = 3000

func move_to(new_position: Vector2, duration: float):
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT_IN)
	tween.tween_property(self, "global_position", new_position, duration)
	await tween.finished
	return true

func _follow_mouse(delta: float):
	var target = get_global_mouse_position()
	var to_target = target - global_position
	var distance = to_target.length()
	var direction = to_target.normalized()
	var speed = clamp(distance / delta, 0, max_speed)
	velocity = direction * speed
	move_and_slide()

func _input(event: InputEvent):
	if dragging and event is InputEventMouseButton and event.pressed == false:
		_on_move_end()
		
func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed == true:
		_on_move_start()

func _on_move_end():
	_snap_to_tile()
	$SwapArea.monitoring = false
	$SwapArea.current_path = []
	dragging = false

func _on_move_start():
	dragging = true
	$SwapArea.monitoring = true
	
func _physics_process(delta: float) -> void:
	if dragging:
		_follow_mouse(delta)

func _snap_to_tile():
	var from = global_position
	var to = snapped(global_position, Vector2.ONE * 64)
	var space_state = get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(from, to, 1 << 2)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		var last_position = $SwapArea.current_path.back().position
		result.collider.move_to(last_position, 0.025)
	await move_to(to, 0.05)
