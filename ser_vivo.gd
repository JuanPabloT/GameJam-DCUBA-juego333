@abstract class_name SerVivo
extends Node


var health
var shield:int = 0
var GD = GameData

@export var health_status : Label
@export var effect_status : StatusEffectHandler
@export var enemy : SerVivo

@export var smokeemitter : GPUParticles2D
@export var flameemmitter : GPUParticles2D
@export var shieldemitter : GPUParticles2D
@export var explosion_emitter : GPUParticles2D
@export var water_emitter : GPUParticles2D
@export var root_emitter : GPUParticles2D
@export var lightning_emitter : GPUParticles2D
@export var poison_emitter : GPUParticles2D
@export var beer_emitter : GPUParticles2D
@export var wind_emitter : Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_shield_visibility()

func is_dead()->bool:
	return health <= 0


func deal_ordinary_damage(n:int):
	shield -= n
	if shield <= 0:
		change_health(shield, "#F00")
		shield = 0
	else:
		display_status("Bloqueado!", "#AAC")
		print("bloqueado ", self.name, " ", shield, " ", shield+n )
		
	update_shield_visibility()

func heal_by(n:int):
	change_health(n, "#0F0")

func on_turn_end():
	print("  (from turn end)")
	await effect_status.trigger_effect_collisions()
	await enemy.effect_status.trigger_effect_collisions()
	if await effect_status.has_effects_to_run():
		await get_tree().create_timer(0.3).timeout
	await effect_status.run_effects()
	
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
	explosion_emitter.restart()
	await get_tree().create_timer(1).timeout
	
	
func apply_water():
	display_status("Lluvia", GD.element_colors[GD.water])
	effect_status.add_water_effect()
	water_emitter.emitting=true
	await get_tree().create_timer(1).timeout

func apply_root():
	display_status("Frondas", GD.element_colors[GD.root])
	effect_status.add_rooted_effect()
	root_emitter.emitting=true
	await get_tree().create_timer(1).timeout

func apply_lightning():
	display_status("Rayo!", GD.element_colors[GD.lightning])
	effect_status.add_shock_effect()
	lightning_emitter.emitting=true
	await get_tree().create_timer(1).timeout

func apply_poison(n:int):
	display_status("Envenenado", GD.element_colors[GD.poison])
	effect_status.add_poison_effect(n)
	poison_emitter.emitting=true
	await get_tree().create_timer(1).timeout

func apply_beer():
	display_status("Emborrachado", GD.element_colors[GD.beer])
	effect_status.add_beer_effect()
	beer_emitter.emitting=true
	await get_tree().create_timer(1).timeout
	
	
	
func smoke():
	smokeemitter.visible = true
	await get_tree().create_timer(1).timeout
	smokeemitter.visible = false
	
	
func add_shield(n:int):
	shield += n
	update_shield_visibility()
	display_status("+"+str(n), "#7BB")

func update_shield_visibility():
	shieldemitter.amount_ratio = clampf(shield/30.0,0,1)
	print(shield, " ", shield/30.0, " ", clampf(shield/30.0,0,1))
	
	
func deal_poison_damage(n:int):
	change_health(-n, GD.element_colors[GD.poison])
	
func apply_wind():
	effect_status.apply_wind()
	display_status("Viento!", "#7BB")
	wind_emitter.visible=true
	await get_tree().create_timer(1).timeout
	wind_emitter.visible=false
	
	
var past_y_positions_of_status_displays = [0,0,0]
	
# funcion fea para poner numeritos
func display_status(text, color):
	var container = Node2D.new()
	add_child(container)
	var ypos = randf_range(-150,-50)
	#while abs(ypos-past_y_positions_of_status_displays[-1]) < 30 or \
	#	  abs(ypos-past_y_positions_of_status_displays[-2]) < 30:
	#	ypos = randf_range(-150,-50)
	#	print(ypos)
	#print(ypos," ", text)
	past_y_positions_of_status_displays.append(ypos)
	
	container.global_position = self.position + Vector2(randf_range(-80,80),ypos)
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
	container.queue_free()
