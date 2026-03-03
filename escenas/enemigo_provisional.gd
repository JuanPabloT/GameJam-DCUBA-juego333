extends SerVivo


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = 150
	pass # Replace with function body.

func on_death():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func on_turn():
	enemy.deal_ordinary_damage(randi_range(15, 0))
