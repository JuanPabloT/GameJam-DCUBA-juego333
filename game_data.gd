extends Node


var logro_max_hp  =false
var todas_partes_artefactos  =false
var matar_bruja_veneno  =false
var matar_elemental_quemandolo  =false
var danio_60_de_una  =false
var reaccionar_5_turno  =false

func notificar_logro(texto):
	pass

var water = "res://sprites/efectos/agua.png"
var beer = "res://sprites/efectos/beer.png"
var fire = "res://sprites/efectos/fuego.png"
var root = "res://sprites/efectos/raices.png"
var lightning = "res://sprites/efectos/rayo.png"
var poison = "res://sprites/efectos/veneno.png"
var warning_scene: PackedScene = preload("res://warning_exit.tscn")

var is_players_turn=false

var effect_passive_effects =  {
	water: "Cura 3 HP",
	beer: "Duplica daño físico dado",	
	poison: "Hace el daño indicado",	
	fire: "Hace 8 daño por la cantidad de turnos indicados",	
	root: "Sin efectos pasivos",	
	lightning: "Sin efectos pasivos",	
}

var element_colors =  {
	water:"#55F",
	beer:"#F72",
	fire:"#F50",
	root:"#474",
	lightning:"#FD7",
	poison:"#84D",
}

var bottom_artifact_pieces = [
	"res://sprites/artefactos/bottom/lamparaD.png",
	"res://sprites/artefactos/bottom/swordD.png",
	"res://sprites/artefactos/bottom/helmetD.png",
	"res://sprites/artefactos/bottom/coronaD.png",
	
]
var top_artifact_pieces = [
	"res://sprites/artefactos/top/ballU.png",
	"res://sprites/artefactos/top/lamparaU.png",
	"res://sprites/artefactos/top/mateU.png",
	"res://sprites/artefactos/top/potU.png",
	
]
var side_artifact_pieces = [
	"res://sprites/artefactos/side/flameE.png",
	"res://sprites/artefactos/side/lamparaE.png",
	"res://sprites/artefactos/side/hornE.png",
	"res://sprites/artefactos/side/moaiE.png",
	
]
var all_artifact_pieces = bottom_artifact_pieces+top_artifact_pieces+side_artifact_pieces

# asi se escriben lambdas/funciones anonimas/block closures en gdscript
var possible_effects = [
	[func(target:SerVivo): await target.heal_by(5), "Curar por 5"],
	[func(target:SerVivo): await target.heal_by(15), "Curar por 15"],
	[func(target:SerVivo): await target.deal_ordinary_damage(10), "Dañar por 10"],
	[func(target:SerVivo): await target.deal_ordinary_damage(20),"Dañar por 20"],
	[func(target:SerVivo): await target.set_on_fire(),  "encender en fuego"],
	[func(target:SerVivo): await target.apply_water(),  "mojar"],
	[func(target:SerVivo): await target.apply_root(),"aplicar planta??"],
	[func(target:SerVivo): await target.apply_lightning(),"Replampago"],
	[func(target:SerVivo): await target.apply_poison(4),"Envenenar"],
	[func(target:SerVivo): await target.apply_beer(),"Tirar cerveza"],
	[func(target:SerVivo): await target.add_shield(15),"Aplicar escudo"],
	[func(target:SerVivo): await target.apply_wind(),"Soplar viento"],
]


# mal nombre de variable. no se que ponerle. diccionario que le asigna a cada
# pieza de artefacto un efecto
var real_effects : Dictionary
var real_effect_descriptions : Dictionary
var real_effect_seen : Dictionary
var real_effect_player_notes : Dictionary

var artefacto_holder : VBoxContainer

func assign_effect_to_artifact_parts():
	# solo funciona si hay suficientes efectos. habria que hacer que se repitan solo si no lo hubiera
	possible_effects.shuffle()
	for i in range(all_artifact_pieces.size()):
		real_effects[all_artifact_pieces[i]] = possible_effects[i][0]
		real_effect_descriptions[all_artifact_pieces[i]] = possible_effects[i][1]
		real_effect_seen[all_artifact_pieces[i]] = false

#Data para el torneo
var level : int
var enemies_remaining : Array
var stage : Array
var player_health : int
