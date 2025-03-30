extends Node2D

class_name Tile

var inside

func _on_area_2d_area_entered(area: Area2D) -> void:
	if not inside:
		inside = area.get_parent()
	print("entered", inside)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if inside:
		inside = null
	print("exited", inside)
