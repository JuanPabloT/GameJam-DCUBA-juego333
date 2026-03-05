extends Node

var characters_skin_head = [
	"res://sprites/cabezas/clemen_tina_head.png",
	"res://sprites/cabezas/fire_elemental_head.png",
	"res://sprites/cabezas/ventilador_head.png",
	"res://sprites/cabezas/pj_small_head.png",
	"res://sprites/cabezas/pj_small_head.png",
	"res://sprites/cabezas/pj_small_head.png",
	"res://sprites/cabezas/pj_small_head.png"
	
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
	$Camera2D/pos5.texture = load(characters_skin_head[GameData.enemies_remaining[3]])
	$Camera2D/pos6.position = Vector2(230, 222)
	$Camera2D/pos6.texture = load(characters_skin_head[GameData.enemies_remaining[4]])
	$Camera2D/pos7.position = Vector2(390, 222)
	$Camera2D/pos7.texture = load(characters_skin_head[GameData.enemies_remaining[5]])
	$Camera2D/pos8.position = Vector2(540, 222)
	$Camera2D/pos8.texture = load(characters_skin_head[GameData.enemies_remaining[6]])
	pass


func _set_stage_2() -> void:
	#settear posicion de cada personaje
	$Camera2D/pos1.position = Vector2(-520, 50)
	
	$Camera2D/pos2.texture = load(characters_skin_head[GameData.enemies_remaining[0]])
	$Camera2D/pos2.position = Vector2(-390, 222)
	
	$Camera2D/pos3.texture = load(characters_skin_head[GameData.enemies_remaining[1]])
	$Camera2D/pos4.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	if randi_range(0, 1) == 0:
		#perdio el de pos 3 y avanza el de pos 4
		GameData.stage[1] = 1
		$Camera2D/pos3.position = Vector2(-230, 222)
		$Camera2D/pos4.position = Vector2(-110, 45)
	else:
		#perdio el de pos 4 y avanza el de pos 3
		GameData.stage[0] = 1
		$Camera2D/pos4.position = Vector2(-80, 222)
		$Camera2D/pos3.position = Vector2(-200, 45)
	
	$Camera2D/pos5.texture = load(characters_skin_head[GameData.enemies_remaining[3]])
	$Camera2D/pos6.texture = load(characters_skin_head[GameData.enemies_remaining[4]])
	if randi_range(0, 1) == 0:
		#perdio el de pos 5 y avanza el de pos 6
		GameData.stage[3] = 1
		$Camera2D/pos5.position = Vector2(80, 222)
		$Camera2D/pos6.position = Vector2(200, 45)
	else:
		#perdio el de pos 6 y avanza el de pos 5
		GameData.stage[2] = 1
		$Camera2D/pos6.position = Vector2(230, 222)
		$Camera2D/pos5.position = Vector2(110, 45)
			
	$Camera2D/pos7.texture = load(characters_skin_head[GameData.enemies_remaining[5]])
	$Camera2D/pos8.texture = load(characters_skin_head[GameData.enemies_remaining[6]])
	if randi_range(0, 1) == 0:
		#perdio el de pos 7 y avanza el de pos 8
		GameData.stage[5] = 1
		$Camera2D/pos7.position = Vector2(390, 222)
		$Camera2D/pos8.position = Vector2(510, 45)
	else:
		#perdio el de pos 8 y avanza el de pos 7
		GameData.stage[4] = 1
		$Camera2D/pos8.position = Vector2(540, 222)
		$Camera2D/pos7.position = Vector2(420, 45)


func _set_stage_3() -> void:
	
	$Camera2D/pos1.position = Vector2(-300, -140)
	
	$Camera2D/pos2.texture = load(characters_skin_head[GameData.enemies_remaining[0]])
	$Camera2D/pos2.position = Vector2(-390, 222)
	
	$Camera2D/pos3.texture = load(characters_skin_head[GameData.enemies_remaining[1]])
	$Camera2D/pos4.texture = load(characters_skin_head[GameData.enemies_remaining[2]])
	if GameData.stage[0] == 1:
		$Camera2D/pos4.position = Vector2(-80, 222)
		$Camera2D/pos3.position = Vector2(-200, 45)
	else:
		$Camera2D/pos3.position = Vector2(-230, 222)
		$Camera2D/pos4.position = Vector2(-110, 45)
	
	$Camera2D/pos5.texture = load(characters_skin_head[GameData.enemies_remaining[3]])
	$Camera2D/pos6.texture = load(characters_skin_head[GameData.enemies_remaining[4]])
	$Camera2D/pos7.texture = load(characters_skin_head[GameData.enemies_remaining[5]])
	$Camera2D/pos8.texture = load(characters_skin_head[GameData.enemies_remaining[6]])
	
	if randi_range(0, 1) == 0:
		#gana el de pos 5 / 6
		if GameData.stage[3] == 1:
			#gano el de pos 6
			GameData.stage[3] = 2
			$Camera2D/pos5.position = Vector2(80, 222)
			$Camera2D/pos6.position = Vector2(310, -140)
		else:
			#gano el de pos 5
			GameData.stage[2] = 2
			$Camera2D/pos6.position = Vector2(230, 222)
			$Camera2D/pos5.position = Vector2(310, -140)
		
		if GameData.stage[5] == 1:
			$Camera2D/pos7.position = Vector2(390, 222)
			$Camera2D/pos8.position = Vector2(510, 45)
		else:
			$Camera2D/pos8.position = Vector2(540, 222)
			$Camera2D/pos7.position = Vector2(420, 45)
		
	else:
		#gana el de pos 7 / 8
		if GameData.stage[5] == 1:
			#gano el de pos 8
			GameData.stage[5] = 2
			$Camera2D/pos7.position = Vector2(390, 222)
			$Camera2D/pos8.position = Vector2(310, -140)
		else:
			#gano el de pos 7
			GameData.stage[4] = 2
			$Camera2D/pos8.position = Vector2(540, 222)
			$Camera2D/pos7.position = Vector2(310, -140)
		
		if GameData.stage[3] == 1:
			$Camera2D/pos5.position = Vector2(80, 222)
			$Camera2D/pos6.position = Vector2(200, 45)
		else:
			$Camera2D/pos6.position = Vector2(230, 222)
			$Camera2D/pos5.position = Vector2(110, 45)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_tournament_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/combate.tscn")


func _on_return_to_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
