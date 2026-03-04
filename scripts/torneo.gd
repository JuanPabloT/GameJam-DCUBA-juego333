extends Node

var enemy_skin_head = [
	"res://sprites/personajes/iconos/clemen_tina_head.png",	
	"res://sprites/personajes/iconos/fire_elemental_head.png",
	"res://sprites/personajes/iconos/liliana_head.png"
]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.level == 1:
		_load_level_1()
	elif GameData.level == 2:
		_load_level_2()
	elif GameData.level == 3:
		_load_level_3()
	pass # Replace with function body.

func _load_level_1() -> void:
	pass

func _load_level_2() -> void:
	pass
	
func _load_level_3() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_return_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")


func _on_next_match_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/combate.tscn")
