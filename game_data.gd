extends Node

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
	[func(target): target.change_health(10), "Curar por 10"],
	[func(target): target.set_on_fire_for(3),  "encender en fuego"],
	[func(target): target.change_health(-5), "Dañar por 5"],
	[func(target): target.change_health(-10),"Dañar por 10"],
	[func(target): target.change_health(20), "Curar por 20"],
	[func(target): target.change_health(-20),"Dañar por 20"],
]


# mal nombre de variable. no se que ponerle. diccionario que le asigna a cada
# pieza de artefacto un efecto
var real_effects : Dictionary
var real_effect_descriptions : Dictionary
var real_effect_player_notes : Dictionary


func assign_effect_to_artifact_parts():
	# solo funciona si hay suficientes efectos. habria que hacer que se repitan solo si no lo hubiera
	possible_effects.shuffle()
	for i in range(all_artifact_pieces.size()):
		real_effects[all_artifact_pieces[i]] = possible_effects[i][0]
		real_effect_descriptions[all_artifact_pieces[i]] = possible_effects[i][1]
