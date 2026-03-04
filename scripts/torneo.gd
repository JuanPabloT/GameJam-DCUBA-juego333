extends Node

var characters_skin_head = [
	"res://sprites/cabezas/clemen_tina_head.png",
	"res://sprites/cabezas/fire_elemental_head.png",
	"res://sprites/cabezas/ventilador_head.png"
	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if GameData.level == 1:
		_set_stage_1()
	elif GameData.level == 2:
		_set_stage_2()
	else:
		_set_stage_3()
	pass # Replace with function body.


func _set_stage_1() -> void:
	#settear posicion de cada personaje
	$Camera2D/pos1.position = Vector2(-540, 222)
	$Camera2D/pos2.position = Vector2(-390, 222)
	$Camera2D/pos2.texture = load(characters_skin_head[GameData.enemies_remaining[0]])
	$Camera2D/pos3.position = Vector2(-230, 222)
	$Camera2D/pos3.texture = load(characters_skin_head[GameData.enemies_remaining[1]])
	$Camera2D/pos4.position = Vector2(-80, 222)
	$Camera2D/pos4.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos5.position = Vector2(80, 222)
	$Camera2D/pos5.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos6.position = Vector2(230, 222)
	$Camera2D/pos6.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos7.position = Vector2(390, 222)
	$Camera2D/pos7.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos8.position = Vector2(540, 222)
	$Camera2D/pos8.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	pass


func _set_stage_2() -> void:
	#settear posicion de cada personaje
	GameData.losers = [0, 0, 0, 0, 0, 0]
	$Camera2D/pos1.position = Vector2(-520, 50)
	$Camera2D/pos2.texture = load(characters_skin_head[GameData.enemies_remaining[0]])
	GameData.losers[0] = GameData.enemies_remaining[0]
	$Camera2D/pos3.texture = load(characters_skin_head[GameData.enemies_remaining[1]])
	$Camera2D/pos4.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	if randi_range(0, 1) == 0:
		#perdio el de pos 3 y avanza el de pos 4
		GameData.losers[1] = GameData.enemies_remaining[1]
		$Camera2D/pos3.position = Vector2(-230, 222)
		GameData.enemies_remaining[0] = GameData.enemies_remaining[2]
		$Camera2D/pos4.position = Vector2(-110, 45)
	else:
		#perdio el de pos 4 y avanza el de pos 3
		GameData.losers[1] = GameData.enemies_remaining[2]
		$Camera2D/pos4.position = Vector2(-80, 222)
		GameData.enemies_remaining[0] = GameData.enemies_remaining[1]
		$Camera2D/pos3.position = Vector2(-200, 45)
	
	$Camera2D/pos5.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos6.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	
	$Camera2D/pos7.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	$Camera2D/pos8.texture = load(characters_skin_head[GameData.enemies_remaining[2]])

	pass


func _set_stage_3() -> void:
	#repetir lo mismo del paso 2
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_tournament_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/combate.tscn")


func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
