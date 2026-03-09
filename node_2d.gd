extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	for child in $"Camera2D/Main Menu/EffectInitiation4CompatRenderer".get_children():
		if "emit" in child:
			child.emit()
		else:
			child.restart() 
		print("precompiled", child.name)
	
	await get_tree().process_frame
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://escenas/torneo.tscn")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
