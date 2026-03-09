extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func animate_down():
	self.visible=true
	#self.modulate.a=0
	self.position.y=-1500
	var tween = create_tween()
	tween.set_parallel()
	#tween.tween_property(self, "modulate:a", 0.8, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position:y", 0, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	#tween.tween_property(self, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT).set_delay(0.6)


func _on_x_pressed() -> void:
	queue_free()


func _on_surrender_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
