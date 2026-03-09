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

var clemen_tina_turn:int = 0
var id : int

func notificar(quecosa):
	var newparent : Control = Label.new()
	#newparent.custom_minimum_size.y=120
	newparent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	newparent.text = characters_skin_names[characters_skin[id]]+" "+quecosa
	newparent.add_theme_font_size_override("font_size", 10)
	newparent.autowrap_mode = TextServer.AUTOWRAP_WORD
	GameData.artefacto_holder.add_child(newparent)
	GameData.artefacto_holder.move_child(newparent, 0)
	


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
	var tween = create_tween()
	tween.tween_property($EnemigoProvisionalSprite.material, "shader_parameter/DissolveValue", 0, 3)

	 

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
	
	match clemen_tina_turn % 3:
		0:
			$EnemigoProvisionalSprite.texture = tina_combat_texture
			match randi_range(0,2):
				0:
					$"../Audio/clemen_tina/tina1".play()
				1:
					$"../Audio/clemen_tina/tina2".play()
			await self.add_shield(5)
			notificar("se aplicó 5 escudo")
			await enemy.apply_water()
			notificar("te aplicó agua")
			var damage = randi_range(3, 6)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		1:
			$EnemigoProvisionalSprite.texture = clemen_combat_texture
			match randi_range(0,2):
				0:
					$"../Audio/clemen_tina/clemen1".play()
				1:
					$"../Audio/clemen_tina/clemen2".play()
			await self.heal_by(7)
			notificar("se curó por 7")
			await enemy.apply_lightning()
			notificar("te aplicó relámpago")
			var damage = randi_range(3, 6)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		2:
			$EnemigoProvisionalSprite.texture = clemen_tina_combat_texture
			$"../Audio/clemen_tina/tina3".play()
			$"../Audio/clemen_tina/clemen3".play()
			await enemy.set_on_fire()
			notificar("te prendió fuego")
			await enemy.apply_poison(2)
			notificar("te aplicó 2 veneno")
			var damage = randi_range(4, 10)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
	clemen_tina_turn+=1

func _elemental_turn() -> void:
	$particlescale/FlameEmmitterBLue.visible=true
	match randi_range(0, 2):
		0:
			$"../Audio/elemental/elemental1".play()
		1:
			$"../Audio/elemental/elemental2".play()
		2:
			$"../Audio/elemental/elemental3".play()
	match randi_range(0,2):
		0:
			await enemy.set_on_fire()
			notificar("te prendió fuego")
			var damage = randi_range(2, 7)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")

		1:
			await enemy.set_on_fire()
			notificar("te prendió fuego")
			await enemy.set_on_fire()
			notificar("te prendió fuego")
		2:
			await self.set_on_fire()
			notificar("se prendió fuego")
			await self.heal_by(10)
			notificar("se curó por 10")
			var damage = randi_range(0, 5)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
	$particlescale/FlameEmmitterBLue.visible=false


func _liliana_turn() -> void:
	$EnemigoProvisionalSprite.texture = liliana_combat_texture
	match randi_range(0,6):
		0,1,2:
			await enemy.apply_wind()
			notificar("te sopló viento")
			var damage = randi_range(4, 8)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		3,4:
			await enemy.apply_wind()
			notificar("te sopló viento")
			await self.apply_wind()
			notificar("se sopló viento")
		5,6:
			await self.set_on_fire()
			notificar("se prendió fuego")
			await self.apply_wind()
			notificar("se sopló viento")
			await enemy.deal_ordinary_damage(5)
			notificar("hizo 5 daño físico")
			

func _gaucho_turn() -> void:
	$EnemigoProvisionalSprite.texture = gaucho_combat_texture
	match randi_range(0, 2):
		0:
			$"../Audio/gaucho/gaucho1".play()
		1:
			$"../Audio/gaucho/gaucho2".play()
		2:
			$"../Audio/gaucho/gaucho3".play()
	match randi_range(0,5):
		0,1,2:
			await self.apply_beer()
			notificar("bebió cerveza")
			var damage = randi_range(4, 7)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		3,4:
			await self.apply_beer()
			notificar("bebió cerveza")
			
			await self.apply_beer()
			notificar("bebió cerveza")
			
			var damage = randi_range(3, 6)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		5:
			await enemy.apply_beer()
			notificar("te aplicó cerveza")
			
			await self.apply_water()
			notificar("se aplicó agua")
			var damage = randi_range(4, 10)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")


func _alien_turn() -> void:
	$EnemigoProvisionalSprite.texture = alien_combat_texture
	match randi_range(0, 2):
		0:
			$"../Audio/alien/alien1".play()
		1:
			$"../Audio/alien/alien2".play()
		2:
			$"../Audio/alien/alien3".play()
	match randi_range(0,3):
		0:
			await enemy.apply_lightning()
			notificar("te aplicó relámpago")
			await self.add_shield(10)
			notificar("se aplicó 10 escudo")
			
		1,2:
			await self.add_shield(5)
			notificar("se aplicó 5 escudo")
			var damage = randi_range(3, 8)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		3:
			await self.apply_wind()
			notificar("se sopló viento")
			var damage = randi_range(4, 10)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")


func _bruja_turn() -> void:
	$EnemigoProvisionalSprite.texture = bruja_combat_texture
	match randi_range(0, 2):
		0:
			$"../Audio/witch/witch1".play()
		1:
			$"../Audio/witch/witch2".play()
		2:
			$"../Audio/witch/witch3".play()
	match randi_range(0,2):
		0:
			await enemy.apply_poison(2)
			notificar("te aplicó 2 veneno")
			
			await self.heal_by(5)
			notificar("se curó por 5")
			
		1:
			await self.apply_water()
			notificar("se aplicó agua")
			await self.heal_by(8)
			notificar("se curó por 8")
			var damage = randi_range(1, 6)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		2:
			await enemy.apply_poison(2)
			notificar("te aplicó 2 veneno")
			
			var damage = randi_range(5, 10)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")


func _apple_turn() -> void:
	$EnemigoProvisionalSprite.texture = apple_combat_texture
	match randi_range(0, 2):
		0:
			$"../Audio/apple/apple1".play()
		1:
			$"../Audio/apple/apple2".play()
		2:
			$"../Audio/apple/apple3".play()
	match randi_range(0,4):
		0,1:
			await enemy.apply_root()
			notificar("te aplicó raices")
			await self.apply_root()
			notificar("se aplicó raices")
			var damage = randi_range(1, 6)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		2,3:
			await enemy.apply_root()
			notificar("te aplicó raices")
			var damage = randi_range(4, 8)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")
		4:
			var damage = randi_range(10, 20)
			await enemy.deal_ordinary_damage(damage)
			notificar("hizo "+str(damage)+" daño físico")


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
