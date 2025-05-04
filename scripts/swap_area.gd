extends Area2D

class_name SwapArea

var current_path = []

func move_to(new_position: Vector2, duration: float):
	var character: PlayableCharacter = get_parent()
	character.move_to(new_position, duration)

func _on_area_entered(area: Area2D):
	if (area is SwapArea):
		_on_swap_area_entered(area)
	else:
		await get_tree().process_frame
		var tile = area.get_parent()
		current_path.append(tile)

func _on_swap_area_entered(area: SwapArea):
	area.move_to(current_path.back().position, 0.05)
