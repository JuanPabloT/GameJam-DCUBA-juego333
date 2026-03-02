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
	pass


func _enable_buttons() -> void:
	$"Camera2D/Buttons control/Consumir".disabled = false
	$"Camera2D/Buttons control/Utilizar".disabled = false
	pass


func _player_lost() -> bool:
	if player.is_dead():
		print("Perdiste, sos malisimo :(")
		return true
	return false

func _player_turn() -> void:
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
	await get_tree().create_timer(1).timeout
	player.on_turn_end()
	if _rival_lost():
		return
	_update_player_health(randi_range(-15, 0))
	rival.on_turn_end()
	_player_turn()


func _on_consumir_pressed() -> void:
	_disable_buttons()
	artifact.use_on(player)
	if player.is_dead():
		return
	_rival_turn()


func _on_utilizar_pressed() -> void:
	_disable_buttons()
	artifact.use_on(rival)
	if _rival_lost():
		return
	_rival_turn()


#func _on_surrender_pressed() -> void:	
	#get_tree().change_scene_to_file("res://mainmenu.tscn")
	##salir


func _update_player_health(value) -> void:
	player.change_health(value)

func _update_rival_health(value) -> void:
	player.change_health(value)
