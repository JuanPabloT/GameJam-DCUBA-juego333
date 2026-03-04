extends SerVivo

var enemy_skin = [
	"res://sprites/personajes/cuerpos/Clemen_Tina.png",
	"res://sprites/personajes/cuerpos/fire_elemental.png",
	"res://sprites/personajes/cuerpos/liliana.png"	
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var enemigo = $EnemigoProvisionalSprite
	enemigo.texture = load(enemy_skin[randi() % enemy_skin.size()])
	health = 150
	
	#esto no es muy objetos pero quiero probar modificar el tamaño
	var size_enemigo = enemigo.texture.get_size()
	var x = 300 / size_enemigo.x
	var y = 300 / size_enemigo.y
	var escala = min(x, y)
	enemigo.scale = Vector2(escala, escala)
	pass # Replace with function body.

func on_death():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_turn():
	enemy.deal_ordinary_damage(randi_range(15, 0))
