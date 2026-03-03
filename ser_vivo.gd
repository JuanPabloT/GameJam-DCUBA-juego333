@abstract class_name SerVivo
extends Node


var health
var shield = 0
var GD = GameData

@export var health_status : Label
@export var effect_status : StatusEffectHandler
@export var enemy : SerVivo

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func is_dead()->bool:
	return health <= 0


func deal_ordinary_damage(n:int):
	change_health(-n, "#F00")

func heal_by(n:int):
	change_health(n, "#0F0")

func on_turn_end():
	pass
	#if turns_on_fire > 0:
	#		turns_on_fire -= 1
	#	change_health(-5, "#F50")



func change_health(amount:int, color=null):
	health += amount
	if health_status != null:
		health_status.text = str(health)
	display_status(str(amount), color if color != null else "#FFF")
		
	if is_dead():
		on_death()
		
@abstract func on_death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
	
	
func set_on_fire():
	display_status("Fuego!", "#F50")
	effect_status.add_flame_effect()
	
func apply_water():
	display_status("Lluvia", GD.element_colors[GD.water])
	effect_status.add_water_effect()

func apply_root():
	display_status("Frondas", GD.element_colors[GD.root])
	effect_status.add_rooted_effect()

func apply_lightning():
	display_status("Rayo!", GD.element_colors[GD.lightning])
	effect_status.add_shock_effect()

func apply_poison(n:int):
	display_status("Envenenado", GD.element_colors[GD.poison])
	effect_status.add_poison_effect(n)

func apply_beer():
	display_status("Emborrachado", GD.element_colors[GD.beer])
	effect_status.add_beer_effect()

	
	
	
	
	
	
	
	
	
	
	
# funcion fea para poner numeritos
func display_status(text, color):
	var container = Node2D.new()
	add_child(container)
	container.global_position = self.position + Vector2(randf_range(-80,80),randf_range(-150,-50))
	var display = Label.new()
	container.add_child(display)
	display.text = text
	display.label_settings = LabelSettings.new()
	display.label_settings.font_color = color
	display.label_settings.font_size = 36
	display.label_settings.outline_color = "#000"
	display.label_settings.outline_size = 1

	# center pivot on the label, so it’s drawn relative to middle
	await display.resized
	display.pivot_offset = display.size * 0.5

	# optional: animate on the Node2D instead of the Label
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(display, "position:y", display.position.y - 24, 0.25).set_ease(Tween.EASE_IN)
	tween.tween_property(display, "position:y", display.position.y, 0.5).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(display, "scale", Vector2.ZERO, 0.25).set_ease(Tween.EASE_IN).set_delay(0.5)
	await tween.finished
	display.queue_free()	
