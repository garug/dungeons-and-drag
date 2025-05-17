extends Node

func _ready() -> void:
	for character in $Characters.get_children():
		GlobalGameBoard.binds.set(character.global_position, character)
