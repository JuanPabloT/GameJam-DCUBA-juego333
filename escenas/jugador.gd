class_name Jugador
extends SerVivo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$JugadorSprite.texture = load("res://sprites/cuerpos/pj_small.png")
	$JugadorSprite.scale = Vector2(0.27, 0.27)
	health = 100 #?
	super._ready()

func on_death() -> void:
	var tween = create_tween()
	tween.tween_property($JugadorSprite.material, "shader_parameter/DissolveValue", 0, 3)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


func _on_fronads_pressed() -> void:
	self.apply_root()


func _on_feugo_pressed() -> void:
	self.set_on_fire()


func _on_lightning_pressed() -> void:
	self.apply_lightning()


func _on_beer_pressed() -> void:
	self.apply_beer()


func _on_agua_pressed() -> void:
	self.apply_water()


func _on_viento_pressed() -> void:
	self.apply_wind()


func _on_veneno_pressed() -> void:
	self.apply_poison(3)
