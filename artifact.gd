extends Node2D
var imageup
var imagedown
var imageright
var initialanimation = true

func setup():
	imageup = GameData.top_artifact_pieces.pick_random()
	imagedown = GameData.bottom_artifact_pieces.pick_random()
	imageright = GameData.side_artifact_pieces.pick_random()
		


func use_on(target):
	#TODO animacion de uso, basandose en posicion de target
	
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "global_position:x", target.global_position.x, 0.2).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", target.global_position.y-50, 0.1).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "global_position:y", target.global_position.y, 0.1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.1)
	await tween.finished
	visible=false
	
	await GameData.real_effects[imageup].call(target)
	await GameData.real_effects[imageright].call(target)
	await GameData.real_effects[imagedown].call(target)
	GameData.real_effect_seen[imageup]=true
	GameData.real_effect_seen[imagedown]=true
	GameData.real_effect_seen[imageright]=true
	self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	scale = Vector2(0.3,0.3)
	position.y = 150
	position.x = -120
	setup()
	$Up.texture = ImageTexture.create_from_image(Image.load_from_file(imageup))
	$Down.texture = ImageTexture.create_from_image(Image.load_from_file(imagedown))
	$Right.texture = ImageTexture.create_from_image(Image.load_from_file(imageright))
	$Up/Tooltip/Label.text = GameData.real_effect_descriptions[imageup] if GameData.real_effect_seen[imageup] else "???"
	$Down/Tooltip/Label.text = GameData.real_effect_descriptions[imagedown] if GameData.real_effect_seen[imagedown] else "???"
	$Right/Tooltip/Label.text = GameData.real_effect_descriptions[imageright] if GameData.real_effect_seen[imageright] else "???"
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if initialanimation:
		position = lerp(position, Vector2(position.x, 0), 0.3)
		if Vector2(position.x, 0).distance_to(position) < 0.1:
			initialanimation = false


func _on_up_area_2d_mouse_entered() -> void:
	$Up/Tooltip.visible=true

func _on_up_area_2d_mouse_exited() -> void:
	$Up/Tooltip.visible=false


func _on_down_area_2d_mouse_entered() -> void:
	$Down/Tooltip.visible=true
	
func _on_down_area_2d_mouse_exited() -> void:
	$Down/Tooltip.visible=false


func _on_right_area_2d_mouse_entered() -> void:
	$Right/Tooltip.visible=true

func _on_right_area_2d_mouse_exited() -> void:
	$Right/Tooltip.visible=false
