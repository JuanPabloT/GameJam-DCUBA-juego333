@abstract class_name SerVivo
extends Node


var health
var shield:int = 0
var GD = GameData

@export var health_status : Label
@export var shield_status : Label
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
@export var small_poison_emitter : GPUParticles2D
@export var beer_emitter : GPUParticles2D
@export var wind_emitter : Node2D
@export var heal_emitter : GPUParticles2D
@export var slash_emitter : GPUParticles2D

@export var audio : Node

var myrealtexture : CompressedTexture2D
var myrealscale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_shield_visibility()
	var mysprite = get_child(0)
	myrealtexture = mysprite.texture
	myrealtexture = mysprite.texture
	myrealscale = mysprite.scale

func is_dead()->bool:
	return health <= 0


func on_turn_end():
	await effect_status.trigger_effect_collisions()
	await enemy.effect_status.trigger_effect_collisions()
	if await effect_status.has_effects_to_run():
		await get_tree().create_timer(0.3).timeout
	await effect_status.run_effects()
	

@abstract func on_death()

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
########### EFECTOS ###########

func has_beer():
	return await effect_status.has_beer()
	
	
func set_on_fire():
	display_status("Fuego!", "#F50")
	effect_status.add_flame_effect()
	match randi_range(1,2):
		1:
			audio.find_child("fuego1").play()
		2:
			audio.find_child("fuego2").play()
	await deal_fire_damage(5)
	
	
func apply_water():
	display_status("Lluvia", GD.element_colors[GD.water])
	effect_status.add_water_effect()
	water_emitter.emit()
	match randi_range(1,2):
		1:
			audio.find_child("gotas1").play()
		2:
			audio.find_child("gotas2").play()
	await get_tree().create_timer(1).timeout

func apply_root():
	display_status("Frondas", GD.element_colors[GD.root])
	effect_status.add_rooted_effect()
	root_emitter.emitting=true
	await get_tree().create_timer(1).timeout

func apply_lightning():
	await emit_lightning()
	effect_status.add_shock_effect()
	match randi_range(1,2):
		1:
			audio.find_child("relampago1").play()
		2:
			audio.find_child("relampago2").play()
	display_status("Rayo!", GD.element_colors[GD.lightning])
	deal_lightning_damage(10)
	
func emit_lightning():
	lightning_emitter.emitting=true
	await get_tree().create_timer(1).timeout
	

func apply_poison(n:int):
	display_status("Envenenado", GD.element_colors[GD.poison])
	effect_status.add_poison_effect(n)
	poison_emitter.emit()
	match randi_range(1,2):
		1:
			audio.find_child("gotas1").play()
		2:
			audio.find_child("gotas2").play()
	await get_tree().create_timer(1).timeout

func apply_beer():
	display_status("Emborrachado", GD.element_colors[GD.beer])
	effect_status.add_beer_effect()
	beer_emitter.emit()
	audio.find_child("beer1").play()
	await get_tree().create_timer(1).timeout
	
	
	
func smoke():
	smokeemitter.visible = true
	await get_tree().create_timer(1).timeout
	match randi_range(1,2):
		1:
			audio.find_child("smoke1").play()
		2:
			audio.find_child("smoke2").play()
	smokeemitter.visible = false
	
	
func add_shield(n:int):
	shield += n
	update_shield_visibility()
	match randi_range(1,2):
		1:
			audio.find_child("barrier1").play()
		2:
			audio.find_child("barrier2").play()
	display_status("+"+str(n)+" Escudo", "#AAA")
	await get_tree().create_timer(1).timeout
	

func apply_wind():
	effect_status.apply_wind()
	display_status("Viento!", "#7BB")
	wind_emitter.emit()
	match randi_range(1,2):
		1:
			audio.find_child("wind1").play()
		2:
			audio.find_child("wind2").play()
	await get_tree().create_timer(1).timeout

func emit_burning_particles():
	flameemmitter.emitting=true
	await get_tree().create_timer(1).timeout
	
func emit_slash():
	slash_emitter.restart()
	await get_tree().create_timer(1).timeout

func emit_healing_particles():
	heal_emitter.restart()
	await get_tree().create_timer(1).timeout

func emit_small_poison():
	small_poison_emitter.emitting=true
	await get_tree().create_timer(1).timeout
	
func shock():
	var shocktexture = load("res://sprites/temp_shock.png")
	for i in range(3):
		var mysprite = get_child(0)
		var asacle = float(myrealtexture.get_image().get_used_rect().size.y) / shocktexture.get_image().get_used_rect().size.y
		print("shock", asacle, " ", myrealtexture.get_image().get_used_rect().size.y, " ", shocktexture.get_image().get_used_rect().size.y, " ", 2*myrealtexture.get_image().get_used_rect().size.y/ shocktexture.get_image().get_used_rect().size.y)
		mysprite.texture = shocktexture
		mysprite.scale = myrealscale*1.5*asacle
		await get_tree().create_timer(0.1).timeout
		mysprite.texture = myrealtexture
		mysprite.scale = myrealscale*1
		await get_tree().create_timer(0.05).timeout
	

func update_shield_visibility():
	shieldemitter.amount_ratio = clampf(shield/60.0,0,1)
	shield_status.text = str(shield)
	shield_status.visible = shield>0
		
	
########### DAÑO ###########
enum ShieldStatus {
	broken,
	alive,
	inexistent
}


func change_health(amount:int, color=null, alternative_text=null):
	if is_dead():
		return
	if health + amount < 110:
		health += amount
	else:
		health = 110
		display_status("Vida maxima!", "#5F5")
	if health_status != null:
		health_status.text = str(health)
	display_status(str(amount) if alternative_text == null else alternative_text , color if color != null else "#FFF")
		
	if is_dead():
		health = 0
		health_status.text = str(health)
		on_death()
		
func change_health_shielded(n, color, alternative_text=null)->ShieldStatus:
	var oldshield = shield
	shield += n
	if shield <= 0:
		change_health(shield, color, alternative_text)
		shield = 0
	
	if oldshield == 0:
		return ShieldStatus.inexistent
	elif shield > 0:
		return ShieldStatus.alive
	else: 
		return ShieldStatus.broken 
	
func deal_poison_damage(n:int):
	change_health(-n, GD.element_colors[GD.poison])
	var tween = create_tween()
	tween.tween_property(get_child(0), "modulate", Color.DARK_VIOLET, 0.5)
	tween.tween_property(get_child(0), "modulate", Color.WHITE, 0.5)
	await tween.finished
	
func deal_fire_damage(n):
	explosion_emitter.restart()
	change_health_shielded(-n, GD.element_colors[GD.fire])
	await get_tree().create_timer(1).timeout
	
func deal_lightning_damage(n):
	var prev_shield = shield
	shock()
	match change_health_shielded(-n, GD.element_colors[GD.lightning]):
		ShieldStatus.inexistent:
			pass
		ShieldStatus.alive:
			display_status(str(-prev_shield+shield)+" Bloqueado!", "#AAC")
		ShieldStatus.broken:
			display_status("Escudo roto!", "#AAC")
	await get_tree().create_timer(1).timeout
	
func deal_burning_damage(n:int):
	change_health(-n, GD.element_colors[GD.fire])
	display_status("En llamas!", GD.element_colors[GD.fire])
	await emit_burning_particles()

@abstract func is_my_turn()

func deal_ordinary_damage(n:int):
	var prev_shield = shield
	match change_health_shielded(-n*(2 if (await enemy.has_beer()) else 1), "#F00",(str(n)+" x 2" if await enemy.has_beer() else null) ):
		ShieldStatus.inexistent:
			pass
		ShieldStatus.alive:
			display_status(str(-prev_shield+shield)+" Bloqueado!", "#AAC")
		ShieldStatus.broken:
			display_status("Escudo roto!", "#AAC")
		
	update_shield_visibility()
	await emit_slash()
	

func heal_by(n:int):
	change_health(n, "#0F0")
	await emit_healing_particles()
	


########### TEXTO ###########
	
	
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
