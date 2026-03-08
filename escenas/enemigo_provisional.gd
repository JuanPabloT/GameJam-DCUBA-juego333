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
	enemy.deal_ordinary_damage(randi_range(15, 0))

	match id:
		0:
			_clemen_tina_turn()
		1:
			_elemental_turn()
		2:
			_liliana_turn()
		3:
			_gaucho_turn()
		4:
			_alien_turn()
		5:
			_bruja_turn()
		6:
			_apple_turn()
		_:
			enemy.deal_ordinary_damage(randi_range(15, 0))

func _clemen_tina_turn() -> void:
	match randi_range(0,2):
		0:
			self.add_shield(5)
			enemy.apply_water()
			enemy.deal_ordinary_damage(randi_range(3, 6))
		1:
			self.heal_by(7)
			enemy.apply_lightning()
			enemy.deal_ordinary_damage(randi_range(3, 6))
		2:
			enemy.set_on_fire()
			enemy.apply_poison(2)
			enemy.deal_ordinary_damage(randi_range(4, 10))
	pass


func _elemental_turn() -> void:
	match randi_range(0,2):
		0:
			enemy.set_on_fire()
			enemy.deal_ordinary_damage(randi_range(2, 7))	
		1:
			enemy.set_on_fire()
			enemy.set_on_fire()
		2:
			self.set_on_fire()
			self.heal_by(10)
			enemy.deal_ordinary_damage(randi_range(0, 5))


func _liliana_turn() -> void:
	match randi_range(0,6):
		0,1,2:
			enemy.apply_wind()
			enemy.deal_ordinary_damage(randi_range(4, 8))
		3,4:
			enemy.apply_wind()
			self.apply_wind()
		5,6:
			self.set_on_fire()
			self.apply_wind()
			enemy.deal_ordinary_damage(5)
			

func _gaucho_turn() -> void:
	match randi_range(0,5):
		0,1,2:
			self.apply_beer()
			enemy.deal_ordinary_damage(randi_range(4, 7))
		3,4:
			self.apply_beer()
			self.apply_beer()
			enemy.deal_ordinary_damage(randi_range(3, 6))
		5:
			enemy.apply_beer()
			self.apply_water()
			enemy.deal_ordinary_damage(randi_range(4, 10))


func _alien_turn() -> void:
	match randi_range(0,3):
		0:
			enemy.apply_lightning()
			self.add_shield(10)
		1,2:
			self.add_shield(5)
			enemy.deal_ordinary_damage(randi_range(3, 8))
		3:
			self.apply_wind()
			enemy.deal_ordinary_damage(randi_range(4, 10))


func _bruja_turn() -> void:
	match randi_range(0,2):
		0:
			enemy.apply_poison(2)
			self.heal_by(5)
		1:
			self.apply_water()
			self.heal_by(8)
			enemy.deal_ordinary_damage(randi_range(1, 6))
		2:
			enemy.apply_poison(2)
			enemy.deal_ordinary_damage(randi_range(5, 10))


func _apple_turn() -> void:
	match randi_range(0,4):
		0,1:
			enemy.apply_root()
			self.apply_root()
			enemy.deal_ordinary_damage(randi_range(1, 6))
		2,3:
			enemy.apply_root()
			enemy.deal_ordinary_damage(randi_range(4, 8))
		4:
			enemy.deal_ordinary_damage(randi_range(10, 20))


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
