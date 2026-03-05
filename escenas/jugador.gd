extends SerVivo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 100 #?
	super._ready()

func on_death() -> void:
	pass


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
