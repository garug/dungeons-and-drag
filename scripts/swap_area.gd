extends Area2D

class_name SwapArea

var current_path = []

func move_to(new_position: Vector2, duration: float):
	var character: PlayableCharacter = get_parent()
	character.move_to(new_position, duration)

func _on_area_entered(area: Area2D):
	await get_tree().process_frame
	var tile = area.get_parent()
	var ally = GlobalGameBoard.binds.get(tile.global_position)
	if ally != null:
		ally.move_to(current_path.back().global_position)
	current_path.append(tile)
