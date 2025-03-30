extends Camera2D

func _ready():
	get_viewport().size_changed.connect(_adjust_zoom)
	_adjust_zoom()


func _adjust_zoom():
	var viewport_size = Vector2(get_viewport().size)
	var scale_x = viewport_size.x / (5 * 64)
	var scale_y = viewport_size.y / (7 * 64)
	var min_scale = min(scale_x, scale_y) * 0.75
	zoom = Vector2(min_scale, min_scale)
