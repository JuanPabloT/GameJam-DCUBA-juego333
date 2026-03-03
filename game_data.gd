extends Node


var water = "res://sprites/efectos/agua.png"
var beer = "res://sprites/efectos/beer.png"
var fire = "res://sprites/efectos/fuego.png"
var root = "res://sprites/efectos/raices.png"
var lightning = "res://sprites/efectos/rayo.png"
var poison = "res://sprites/efectos/veneno.png"

var element_colors =  {
	water:"#55F",
	beer:"#F72",
	fire:"#F55",
	root:"#474",
	lightning:"#FD7",
	poison:"#84D",
}

var bottom_artifact_pieces = [
	"res://sprites/artefactos/bottom/lamparaD.png",
	"res://sprites/artefactos/bottom/swordD.png",
	"res://sprites/artefactos/bottom/helmetD.png"
	
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
	"res://sprites/artefactos/side/hornE.png"
	
]
var all_artifact_pieces = bottom_artifact_pieces+top_artifact_pieces+side_artifact_pieces

# asi se escriben lambdas/funciones anonimas/block closures en gdscript
var possible_effects = [
	[func(target:SerVivo): target.heal_by(5), "Curar por 5"],
	[func(target:SerVivo): target.heal_by(15), "Curar por 15"],
	[func(target:SerVivo): target.deal_ordinary_damage(10), "Dañar por 10"],
	[func(target:SerVivo): target.deal_ordinary_damage(20),"Dañar por 20"],
	[func(target:SerVivo): target.set_on_fire(),  "encender en fuego"],
	[func(target:SerVivo): target.apply_water(),  "mojar"],
	[func(target:SerVivo): target.apply_root(),"aplicar planta??"],
	[func(target:SerVivo): target.apply_lightning(),"Replampago"],
	[func(target:SerVivo): target.apply_poison(4),"Envenenar"],
	[func(target:SerVivo): target.apply_beer(),"Tirar cerveza"],
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
