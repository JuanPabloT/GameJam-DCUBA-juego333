class_name Artefacto
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
	
	if not GameData.todas_partes_artefactos:
		GameData.todas_partes_artefactos=true
		for key in GameData.real_effect_seen:
			GameData.todas_partes_artefactos &= GameData.real_effect_seen[key]
		if GameData.todas_partes_artefactos:
			GameData.notificar_logro("Desbloqueaste el logro de artefactos")
	
	get_parent().remove_child(self)
	visible=true
	var newparent : Control = CenterContainer.new()
	newparent.custom_minimum_size.y=120
	newparent.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.scale = Vector2(0.2,0.2)
	GameData.artefacto_holder.add_child(newparent)
	GameData.artefacto_holder.move_child(newparent, 0)
	newparent.add_child(self) 
	prepare_label_text()
	self.position = newparent.size / 2
	self.position.x+=85
	
	$Right/Tooltip.position=Vector2(-200,-100)
	$Down/Tooltip.position=Vector2(-200,-100)
	$Up/Tooltip.position=Vector2(-200,-100)

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	scale = Vector2(0.3,0.3)
	position.y = 150
	position.x = -100
	setup()
	$Up.texture = load(imageup)
	$Down.texture = load(imagedown)
	$Right.texture = load(imageright)
	prepare_label_text()	
	

func prepare_label_text():
	$Up/Tooltip/Label.text = GameData.real_effect_descriptions[imageup] if GameData.real_effect_seen[imageup] else "???"
	$Down/Tooltip/Label.text = GameData.real_effect_descriptions[imagedown] if GameData.real_effect_seen[imagedown] else "???"
	$Right/Tooltip/Label.text = GameData.real_effect_descriptions[imageright] if GameData.real_effect_seen[imageright] else "???"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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
