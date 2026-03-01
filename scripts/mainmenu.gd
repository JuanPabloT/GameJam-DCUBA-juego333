extends Node

func _on_salir_pressed() -> void:
	#salir
	get_tree().quit()
	pass
	get_tree().quit()
	#salir

func _on_iniciar_pressed() -> void:
	print("iniciando")
	get_tree().change_scene_to_file("res://escenas/combate.tscn")
	pass # Replace with function body.


func _on_tutorial_pressed() -> void:
	print("accediendo a tutorial")
	get_tree().change_scene_to_file("res://escenas/Tutorial.tscn")
	pass # Replace with function body.


func _on_logros_pressed() -> void:
	print("logros")
	pass
