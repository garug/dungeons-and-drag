extends CharacterBody2D

class_name PlayableCharacter

var dragging = false

var max_speed = 3000

var attack = 1000

var deffense = 1000

var life: int

var last_pos

func move_to(new_position: Vector2, duration = 0.05):
	print(self, " moving to ", new_position, last_pos)
	GlobalGameBoard.binds.erase(last_pos)
	last_pos = new_position
	GlobalGameBoard.binds.set(new_position, self)
	var tween := create_tween()
	tween.set_ease(Tween.EASE_OUT)
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
	GlobalGameBoard.binds.set(global_position, self)
	$SwapArea.monitoring = false
	$SwapArea.current_path = []
	dragging = false

func _on_move_start():
	GlobalGameBoard.binds.erase(global_position)
	dragging = true
	$SwapArea.monitoring = true
	
func _physics_process(delta: float) -> void:
	if dragging:
		_follow_mouse(delta)
		
func _ready():
	last_pos = global_position

func _snap_allies(to: Vector2):
	var ally = GlobalGameBoard.binds.get(to)
	if ally != null:
		ally.move_to($SwapArea.current_path.back().global_position)
	#var from = global_position
	#var space_state = get_world_2d().direct_space_state
	#var query := PhysicsRayQueryParameters2D.create(from, to, 1 << 3)
	#query.collide_with_areas = true
	#var result = space_state.intersect_ray(query)
	#if result:
		#var last_position = $SwapArea.current_path.back().position
		#result.collider.move_to(last_position, 0.025)

func _snap_to_tile():
	var to = snapped(global_position, Vector2.ONE * 64)
	_snap_allies(to)
	print("eend of action moving to ", to)
	await move_to(to, 0.05)
