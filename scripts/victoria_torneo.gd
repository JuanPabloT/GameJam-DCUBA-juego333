extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameData.victorialogro = true
	GameData.notificar_logro("Conseguiste el logro del secreto")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
