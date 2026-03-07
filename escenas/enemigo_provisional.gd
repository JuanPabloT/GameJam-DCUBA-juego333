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
