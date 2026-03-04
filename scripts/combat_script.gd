extends Node


var player
var rival
var artifact

var artifact_scene: PackedScene = preload("res://artefacto.tscn")

# no se si hay alguna mejor manera de hacer esto. se podrian crawlear los directorios?

func _on_ready() -> void:
	player = $Jugador
	rival = $EnemigoProvisional
	GameData.assign_effect_to_artifact_parts()
	#empiezan los botones apagados
	_disable_buttons()
	_player_turn()

	
	
func _disable_buttons() -> void:
	$"Camera2D/Buttons control/Consumir".disabled = true
	$"Camera2D/Buttons control/Utilizar".disabled = true


func _enable_buttons() -> void:
	$"Camera2D/Buttons control/Consumir".disabled = false
	$"Camera2D/Buttons control/Utilizar".disabled = false


func _player_lost() -> bool:
	if player.is_dead():
		print("Perdiste, sos malisimo :(")
		return true
	return false

func _player_turn() -> void:
	print("turno jugador:")
	if _player_lost():
		return
	#generamos un artefacto
	artifact = spawn_artifact() #randi_range(-20, 10)
	_enable_buttons()
	
func spawn_artifact()->Node:
	var res = artifact_scene.instantiate()
	add_child(res)
	return res

func _rival_lost() -> bool:
	if rival.is_dead():
		print("Ganaste :D")
		return true
	return false

func _rival_turn() -> void:
	print("terminando turno jugador")
	await player.on_turn_end()
	await get_tree().create_timer(0.3).timeout
	print("turno rival:")
	if _rival_lost():
		return
	await rival.on_turn()
	print("terminando turno rival")
	await rival.on_turn_end()
	_player_turn()


func _on_consumir_pressed() -> void:
	print("consumiendo artefacto")
	_disable_buttons()
	await artifact.use_on(player)
	if player.is_dead():
		return
	_rival_turn()


func _on_utilizar_pressed() -> void:
	print("utilizando artefacto")
	_disable_buttons()
	await artifact.use_on(rival)
	if _rival_lost():
		return
	_rival_turn()


#func _on_surrender_pressed() -> void:	
	#get_tree().change_scene_to_file("res://mainmenu.tscn")
	##salir


	
