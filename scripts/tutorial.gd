extends Node


func _on_retorno_pressed() -> void:
	#retornar al main menu
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
