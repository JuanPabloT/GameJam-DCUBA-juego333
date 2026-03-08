class_name Enemigo
extends SerVivo

var characters_skin = [
	"res://sprites/cuerpos/clemen_tina.png",
	"res://sprites/cuerpos/fire_elemental.png",
	"res://sprites/cuerpos/liliana.png",
	"res://sprites/cuerpos/gaucho.png",
	"res://sprites/cuerpos/alien.png",
	"res://sprites/cuerpos/bruja.png",
	"res://sprites/cuerpos/apple.png"
]

var characters_skin_names = {
	"res://sprites/cuerpos/clemen_tina.png": "Clemen-Tina",
	"res://sprites/cuerpos/fire_elemental.png": "Pedro",
	"res://sprites/cuerpos/liliana.png": "Liliana",
	"res://sprites/cuerpos/gaucho.png": "Estebán Fierro",
	"res://sprites/cuerpos/alien.png": "Glorp Zorp d'Lorp",
	"res://sprites/cuerpos/bruja.png": "Piruja",
	"res://sprites/cuerpos/apple.png": "Manzana"
}

var characters_skin_descriptions = {
	"res://sprites/cuerpos/clemen_tina.png": "Recién salidos del dpto Biodiversidad y Biología Experimental de exactas",
	"res://sprites/cuerpos/fire_elemental.png": "Elemental de fuego deshonrado",
	"res://sprites/cuerpos/liliana.png": "En su segundo de nueve meses de vacaciones de invierno",
	"res://sprites/cuerpos/gaucho.png": "Alcohólico en \"recuperación\"",
	"res://sprites/cuerpos/alien.png": "Estrenando la nave",
	"res://sprites/cuerpos/bruja.png": "Buscando los buhos perdidos",
	"res://sprites/cuerpos/apple.png": "Heraldo Apoliónico"
}


var alien_combat_texture = load("res://sprites/cuerpos/alien_cast.png")
var apple_combat_texture = load("res://sprites/cuerpos/apple_cast.png")
var bruja_combat_texture = load("res://sprites/cuerpos/bruja_cast.png")
var clemen_combat_texture = load("res://sprites/cuerpos/clemen_tina_clemen_cast.png")
var tina_combat_texture = load("res://sprites/cuerpos/clemen_tina_tina_cast.png")
var clemen_tina_combat_texture = load("res://sprites/cuerpos/clemen_tina_clemen_tina_cast.png")
var gaucho_combat_texture = load("res://sprites/cuerpos/gaucho_cast.png")
var liliana_combat_texture = load("res://sprites/cuerpos/liliana_cast.png")


var id : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_identify_me()
	$EnemigoProvisionalSprite.texture = load(characters_skin[id])
	match id:
		0:
			$EnemigoProvisionalSprite.scale = Vector2(0.4, 0.4)
		1:
			$EnemigoProvisionalSprite.scale = Vector2(0.4, 0.4)
		3:
			$EnemigoProvisionalSprite.scale = Vector2(0.33, 0.33)
		4:
			$EnemigoProvisionalSprite.scale = Vector2(0.55, 0.55)
		5:
			$EnemigoProvisionalSprite.scale = Vector2(0.35, 0.35)
		_:
			$EnemigoProvisionalSprite.scale = Vector2(0.3, 0.3)
	health = 100
	super._ready()
	pass # Replace with function body.

func on_death():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	pass

func on_turn():
	var current_texture = $EnemigoProvisionalSprite.texture

	match id:
		0:
			await _clemen_tina_turn()
		1:
			await _elemental_turn()
		2:
			await _liliana_turn()
		3:
			await _gaucho_turn()
		4:
			await _alien_turn()
		5:
			await _bruja_turn()
		6:
			await _apple_turn()
		_:
			await enemy.deal_ordinary_damage(randi_range(15, 0))
			
	$EnemigoProvisionalSprite.texture = current_texture

func _clemen_tina_turn() -> void:
	match randi_range(0,2):
		0:
			$EnemigoProvisionalSprite.texture = tina_combat_texture
			await self.add_shield(5)
			await enemy.apply_water()
			#await enemy.deal_ordinary_damage(randi_range(3, 6))
		1:
			$EnemigoProvisionalSprite.texture = clemen_combat_texture
			await self.heal_by(7)
			await enemy.apply_lightning()
			#await enemy.deal_ordinary_damage(randi_range(3, 6))
		2:
			$EnemigoProvisionalSprite.texture = clemen_tina_combat_texture
			await enemy.set_on_fire()
			await enemy.apply_poison(2)
			await enemy.deal_ordinary_damage(randi_range(4, 10))
	pass


func _elemental_turn() -> void:
	$particlescale/FlameEmmitterBLue.visible=true
	match randi_range(0,2):
		0:
			await enemy.set_on_fire()
			await enemy.deal_ordinary_damage(randi_range(2, 7))	
		1:
			await enemy.set_on_fire()
			await enemy.set_on_fire()
		2:
			await self.set_on_fire()
			await self.heal_by(10)
			await enemy.deal_ordinary_damage(randi_range(0, 5))
	$particlescale/FlameEmmitterBLue.visible=false


func _liliana_turn() -> void:
	$EnemigoProvisionalSprite.texture = liliana_combat_texture
	match randi_range(0,6):
		0,1,2:
			await enemy.apply_wind()
			await enemy.deal_ordinary_damage(randi_range(4, 8))
		3,4:
			await enemy.apply_wind()
			await self.apply_wind()
		5,6:
			await self.set_on_fire()
			await self.apply_wind()
			await enemy.deal_ordinary_damage(5)
			

func _gaucho_turn() -> void:
	$EnemigoProvisionalSprite.texture = gaucho_combat_texture
	match randi_range(0,5):
		0,1,2:
			await self.apply_beer()
			await enemy.deal_ordinary_damage(randi_range(4, 7))
		3,4:
			await self.apply_beer()
			await self.apply_beer()
			await enemy.deal_ordinary_damage(randi_range(3, 6))
		5:
			await enemy.apply_beer()
			await self.apply_water()
			await enemy.deal_ordinary_damage(randi_range(4, 10))


func _alien_turn() -> void:
	$EnemigoProvisionalSprite.texture = gaucho_combat_texture
	match randi_range(0,3):
		0:
			await enemy.apply_lightning()
			await self.add_shield(10)
		1,2:
			await self.add_shield(5)
			await enemy.deal_ordinary_damage(randi_range(3, 8))
		3:
			await self.apply_wind()
			await enemy.deal_ordinary_damage(randi_range(4, 10))


func _bruja_turn() -> void:
	$EnemigoProvisionalSprite.texture = bruja_combat_texture
	match randi_range(0,2):
		0:
			await enemy.apply_poison(2)
			await self.heal_by(5)
		1:
			await self.apply_water()
			await self.heal_by(8)
			await enemy.deal_ordinary_damage(randi_range(1, 6))
		2:
			await enemy.apply_poison(2)
			await enemy.deal_ordinary_damage(randi_range(5, 10))


func _apple_turn() -> void:
	$EnemigoProvisionalSprite.texture = apple_combat_texture
	match randi_range(0,4):
		0,1:
			await enemy.apply_root()
			await self.apply_root()
			await enemy.deal_ordinary_damage(randi_range(1, 6))
		2,3:
			await enemy.apply_root()
			await enemy.deal_ordinary_damage(randi_range(4, 8))
		4:
			await enemy.deal_ordinary_damage(randi_range(10, 20))


func _on_beer_pressed() -> void:
	self.apply_beer()
	
func _identify_me() -> void:
	if GameData.level == 1:
		id = GameData.enemies_remaining[0]
	elif GameData.level == 2:
		if GameData.stage[0] == 1:
			id = GameData.enemies_remaining[1]
		else:
			#GameData.stage[1] == 1
			id = GameData.enemies_remaining[2]
	else:
		for i in range(4):
			if GameData.stage[i+2] == 2:
				id = GameData.enemies_remaining[i + 3]
				break
	return
