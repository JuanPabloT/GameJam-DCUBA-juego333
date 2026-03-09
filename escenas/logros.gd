extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $Camera2D/background.get_children():
		child.modulate = Color(1,1,1,0.5)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
