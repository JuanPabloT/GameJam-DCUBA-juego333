extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func emit():
	self.restart()
	await get_tree().create_timer(0.4).timeout
	$Node2D2.restart()
	await get_tree().create_timer(0.2).timeout
	$Node2D2/GPUParticles2D.restart()
	await get_tree().create_timer(0.2).timeout
	
