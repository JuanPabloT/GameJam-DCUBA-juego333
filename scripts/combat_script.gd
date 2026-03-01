extends Node


var player
var rival
var artifact

var artifact_scene: PackedScene = preload("res://artefacto.tscn")

# no se si hay alguna mejor manera de hacer esto. se podrian crawlear los directorios?
# ademas, creo que todo esto deberia estar en un resource. no se como funcionan esos, pero 
# si no los detalles de como se genera el artefacto tienen que quedar en este archivo que queda feo
var bottom_artifact_pieces = [
	"res://sprites/artefactos/bottom/lamparaD.png",
	"res://sprites/artefactos/bottom/swordD.png"
	
]
var top_artifact_pieces = [
	"res://sprites/artefactos/top/ballU.png",
	"res://sprites/artefactos/top/lamparaU.png"
	
]
var side_artifact_pieces = [
	"res://sprites/artefactos/side/flameE.png",
	"res://sprites/artefactos/side/lamparaE.png"
]
var all_artifact_pieces = bottom_artifact_pieces+top_artifact_pieces+side_artifact_pieces

# asi se escriben lambdas/funciones anonimas/block closures en gdscript
var possible_effects = [
	func(target): target.change_health(10),
	func(target): target.change_health(5),
	func(target): target.change_health(-5),
	func(target): target.change_health(-10),
	func(target): target.change_health(20),
	func(target): target.change_health(-20),
]

# mal nombre de variable. no se que ponerle. diccionario que le asigna a cada
# pieza de artefacto un efecto
var real_effects : Dictionary

func _on_ready() -> void:
	player = $Jugador
	rival = $EnemigoProvisional
	assign_effect_to_artifact_parts()
	#empiezan los botones apagados
	_disable_buttons()
	_player_turn()

func assign_effect_to_artifact_parts():
	# solo funciona si hay suficientes efectos. habria que hacer que se repitan solo si no lo hubiera
	possible_effects.shuffle()
	for i in range(all_artifact_pieces.size()):
		real_effects[all_artifact_pieces[i]] = possible_effects[i]
	
	
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
	res.setup(
		top_artifact_pieces.pick_random(),
		bottom_artifact_pieces.pick_random(),
		side_artifact_pieces.pick_random(),
		self
	)
	add_child(res)
	return res

func _rival_lost() -> bool:
	if rival.is_dead():
		print("Ganaste :D")
		return true
	return false

func _rival_turn() -> void:
	if _rival_lost():
		return
	_update_player_health(randi_range(-15, 0))
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
