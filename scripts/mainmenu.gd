extends Node

func _ready() -> void:
	GameData.level = 1
	GameData.enemies_remaining = [0,1,2,3,4,5,6]
	GameData.enemies_remaining.shuffle()
	GameData.stage = [0,0,0,0,0,0]
	GameData.player_health = 100

		

func _on_salir_pressed() -> void:
	#salir
	get_tree().quit()

func _on_iniciar_pressed() -> void:
	print("iniciando")
	get_tree().change_scene_to_file("res://escenas/render.tscn")


func _on_tutorial_pressed() -> void:
	print("accediendo a tutorial")
	get_tree().change_scene_to_file("res://escenas/Tutorial.tscn")


func _on_logros_pressed() -> void:
	print("logros")
	get_tree().change_scene_to_file("res://escenas/logros.tscn")

func _on_cartas_usadas_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/cartas_usadas.tscn")
