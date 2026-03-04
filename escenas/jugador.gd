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
