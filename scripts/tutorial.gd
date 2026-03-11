extends Node


func _on_retorno_pressed() -> void:
	#retornar al main menu
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")


func _on_iniciar_2_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/tutorial2.tscn")
	pass # Replace with function body.
	
	


func _on_volver_a_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
	pass # Replace with function body.


func _on_pagina_anterior_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/Tutorial.tscn")
	pass # Replace with function body.
