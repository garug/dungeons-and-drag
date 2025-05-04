extends Node2D

var from := Vector2.ZERO
var to := Vector2.ZERO

var collision = Vector2.ZERO

func _physics_process(_delta):
	from = global_position
	to = get_global_mouse_position()
	queue_redraw()

	var space_state = get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(from, to, 1 << 2)
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	collision = result.get("position", to)

func _draw():
	draw_line(from, to, Color.RED, 2)
	draw_circle(collision, 4, Color.YELLOW)
