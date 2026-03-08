extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func animate():
	self.visible=true
	self.modulate.a=0
	self.position.y=1000
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 0.8, 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position:y", -200, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT).set_delay(0.6)
	
func animate_side(dist:int):
	print("animating slide ", name)
	self.visible=true
	self.modulate.a=0
	self.position.x=500
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "modulate:a", 1, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUINT)
	tween.tween_property(self, "position:x", -dist, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	await  tween.finished
	
func dissappear():
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT)
	await  tween.finished
	
