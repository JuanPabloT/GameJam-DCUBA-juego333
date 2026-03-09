class_name StatusEffectHandler
extends HBoxContainer


@export var target : SerVivo

enum PreservedStatusEffect {
	first,
	second,
	both,
	neither
}
var P = PreservedStatusEffect
var GD = GameData

var effect_collisions_mutex = Mutex.new()

# otra vez, esto deberia ser un recurso, no undiccionario. creo
var reaction_data = {
	GD.fire: {
		GD.fire:[P.first, func(e1,e2): target.deal_fire_damage(10); e1.set_duration(max(e1.duration, e2.duration)) ],
		GD.water:[P.neither, func(_e1,_e2):target.smoke(); target.display_status("Extinguido!", "#AAA")],
		GD.root:[P.first, func(e1,_e2):e1.add_duration(3); target.display_status("Combustible!", GD.element_colors[GD.fire]); target.emit_burning_particles() ],
		GD.lightning:[P.both, func(_e1,_e2):pass ], 
		GD.poison:[P.first, func(_e1,_e2):target.display_status("Pasteurizar!", GD.element_colors[GD.poison]);target.smoke() ], 
		GD.beer:[P.first, func(e1,_e2):e1.add_duration(3); target.display_status("Moletov!", GD.element_colors[GD.beer]);target.explosion_emitter.restart() ], 
	},
	GD.water: {
		GD.fire:[P.neither, func(_e1,_e2):target.smoke();target.display_status("Extinguido!", "#AAA")],
		GD.water:[P.first, func(_e1,_e2):target.heal_by(10); target.display_status("Elixir!", GD.element_colors[GD.water])],
		GD.root:[P.second, func(_e1,_e2):target.add_shield(10);  target.display_status("Atrincherar!", GD.element_colors[GD.root])], 
		GD.lightning:[P.first, func(_e1,_e2):target.deal_lightning_damage(15); target.display_status("Descarga!", GD.element_colors[GD.lightning]) ], 
		GD.poison:[P.second, func(_e1,e2):e2.dilute();target.display_status("Diluir!", GD.element_colors[GD.water]);target.emit_small_poison() ],
		GD.beer:[P.both, func(_e1,_e2):pass ], 
	},
	GD.root: {
		GD.fire:[P.second, func(_e1,e2):e2.add_duration(3); target.display_status("Combustible!", GD.element_colors[GD.fire]); target.emit_burning_particles() ],
		GD.water:[P.first, func(_e1,_e2):target.add_shield(10); target.display_status("Atrincherar!", GD.element_colors[GD.root]) ], 
		GD.root:[P.first, func(e1,_e2):change_effect(e1, GD.beer); target.display_status("Fermentación!", GD.element_colors[GD.beer]); target.emit_small_poison() ],
		GD.lightning:[P.both, func(_e1,_e2):pass ], 
		GD.poison:[P.both, func(_e1,_e2):pass ],
		GD.beer:[P.neither, func(_e1,_e2):target.display_status("Estropeado!", GD.element_colors[GD.beer]);target.emit_small_poison() ], 
	},
	GD.lightning: {
		GD.fire:[P.both, func(_e1,_e2):pass ], 
		GD.water:[P.second, func(_e1,_e2):target.deal_lightning_damage(15); target.display_status("Descarga!", GD.element_colors[GD.lightning]);target.shock()  ],
		GD.root:[P.both, func(_e1,_e2):pass ], 
		GD.lightning:[P.first, func(_e1,_e2):  target.emit_lightning(); await target.enemy.emit_lightning();target.display_status("Corto-circuito!", GD.element_colors[GD.lightning]);target.enemy.deal_lightning_damage(15) ], 
		GD.poison:[P.neither, func(_e1,_e2):target.display_status("Antidoto!", GD.element_colors[GD.poison]);target.emit_small_poison() ], 
		GD.beer:[P.first, func(_e1,_e2): target.deal_lightning_damage(10);target.display_status("Icáreo!", GD.element_colors[GD.lightning]) ],
	},
	GD.poison: {
		GD.fire:[P.second, func(_e1,_e2):target.display_status("Pasteurizar!", GD.element_colors[GD.poison]);target.smoke() ], 
		GD.water:[P.first, func(e1,_e2):e1.dilute();target.display_status("Diluir!", GD.element_colors[GD.water]);target.emit_small_poison()  ],
		GD.root:[P.both, func(_e1,_e2):pass ],
		GD.lightning:[P.neither, func(_e1,_e2):target.display_status("Antidoto!", GD.element_colors[GD.poison]);target.emit_small_poison() ], 
		GD.poison:[P.first, func(e1,e2):e1.concentrate(e2.potency);target.emit_small_poison() ], 
		GD.beer:[P.both, func(_e1,_e2):pass ],
	},
	GD.beer: {
		GD.fire:[P.second, func(_e1,e2):e2.add_duration(3); target.display_status("Moletov!", GD.element_colors[GD.beer]); target.explosion_emitter.restart() ],
		GD.water:[P.both, func(_e1,_e2):pass ], 
		GD.root:[P.neither, func(_e1,_e2):target.display_status("Estropeado!", GD.element_colors[GD.beer]);target.emit_small_poison() ], 
		GD.lightning:[P.second, func(_e1,_e2): target.change_health(-10, GD.element_colors[GD.lightning]);target.display_status("Icáreo!", GD.element_colors[GD.lightning]) ], 
		GD.poison:[P.both, func(_e1,_e2):pass ],
		GD.beer:[P.first, func(e1,_e2):change_effect(e1, GD.poison);e1.potency = 4;target.display_status("Entoxicación!", GD.element_colors[GD.poison]);target.emit_small_poison() ], 
	}, 
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _get_effect_list()->Array[StatusEffect] :
	await Engine.get_main_loop().process_frame
	var efectos: Array[StatusEffect] 
	efectos.assign(get_children())
	return efectos

func run_effects():
	var efectos = await _get_effect_list()
	for efecto in efectos:
		match efecto.type:
			GD.root, GD.lightning, GD.beer:
				pass
			GD.poison:
				target.deal_poison_damage(efecto.potency)
				await efecto.animate_trigger(0.3)
			GD.water:
				target.heal_by(3)
				await efecto.animate_trigger(0.3)
			GD.fire:
				if efecto.duration > 0:
					target.deal_burning_damage(8)
					await efecto.animate_trigger(0.3)
					efecto.update_duration()
	

func has_effects_to_run():
	var efectos = await _get_effect_list()
	for efecto in efectos:
		match efecto.type:
			GD.root, GD.lightning, GD.beer:
				pass
			GD.poison, GD.water:
				return true
			GD.fire:
				if efecto.duration > 0:
					return true
	return false
	
func has_beer():
	var efectos = await _get_effect_list()
	for efecto in efectos:
		if efecto.type == GD.beer:
			return true
	return false

func add_effect(sprite, duration = 0, potency = 0):
	var neweffect = StatusEffect.new()
	change_effect(neweffect, sprite)
	neweffect.duration = duration
	neweffect.potency = potency
	add_child(neweffect)
	var tooltip = PanelContainer.new()
	neweffect.add_child(tooltip)
	tooltip.visible=false
	tooltip.mouse_filter=Control.MOUSE_FILTER_IGNORE
	tooltip.custom_minimum_size = Vector2(200, 50)
	tooltip.z_index=10
	tooltip.position = Vector2(-60,50)
	var label = Label.new()
	tooltip.add_child(label)
	var stylebox = StyleBoxFlat.new()
	stylebox.bg_color = Color(0,0,0,0.4)
	tooltip.add_theme_stylebox_override("panel",stylebox)
	label.text=GameData.effect_passive_effects[sprite]
	label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode=TextServer.AUTOWRAP_WORD
	neweffect.connect("mouse_entered", func():tooltip.visible=true)
	neweffect.connect("mouse_exited", func():tooltip.visible=false)
	
	

func change_effect(e1, sprite):
	e1.texture = load(sprite)
	e1.name = sprite.split("/")[-1].split(".")[0]
	e1.type = sprite
	e1.duration = 0
	e1.potency = 0
	
		

func trigger_effect_collisions():
	print("  triggering effect collisions for ", target.name)
	var efectos = await _get_effect_list()
	var i = 0
	while i < efectos.size()-1:
		var next_reaction_type = reaction_data[efectos[i].type][efectos[i+1].type][0]
		var next_reaction_effect = reaction_data[efectos[i].type][efectos[i+1].type][1]
		match next_reaction_type:
			P.neither, P.first, P.second:
				match randi_range(1,6):
					1:
						$"../../Audio/combinacion/vibracion1".play()
					2:
						$"../../Audio/combinacion/vibracion2".play()
					3:
						$"../../Audio/combinacion/vibracion3".play()
					4:
						$"../../Audio/combinacion/vibracion4".play()
					5:
						$"../../Audio/combinacion/vibracion5".play()
					6:
						$"../../Audio/combinacion/vibracion6".play()
				efectos[i+1].animate_merge(0.5)
				await efectos[i].animate_merge(0.5)
			P.both:
				pass
		await next_reaction_effect.call(efectos[i], efectos[i+1])
		match next_reaction_type:
			P.neither:
				efectos[i].queue_free()
				efectos.remove_at(i)
				efectos[i].queue_free()
				efectos.remove_at(i)
				i -= 1
			P.second:
				efectos[i].queue_free()
				efectos.remove_at(i)
				i -= 1
			P.first:
				efectos[i+1].queue_free()
				efectos.remove_at(i+1)
			P.both:
				i += 1
		if i < 0:
			i = 0
			
	

func add_flame_effect():
	add_effect(GD.fire)
func add_water_effect():
	add_effect(GD.water)
func add_beer_effect():
	add_effect(GD.beer)
func add_rooted_effect():
	add_effect(GD.root)
func add_poison_effect(n):
	add_effect(GD.poison, 0, n)
func add_shock_effect():
	add_effect(GD.lightning)
func apply_wind():
	var efectos = await _get_effect_list()
	var i = 0
	for efecto in efectos:
		if efecto.type in [GD.water, GD.fire, GD.poison]:
			var efpos = efecto.global_position
			self.remove_child(efecto)
			get_tree().root.get_child(0).add_child(efecto)
			efecto.global_position=efpos
			var tween = create_tween()
			tween.set_parallel()
			print("tweening_wind")
			tween.tween_property(efecto, "global_position:x", target.enemy.effect_status.global_position.x, 0.5).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(efecto, "global_position:y", target.enemy.effect_status.global_position.y-50, 0.25).set_ease(Tween.EASE_IN_OUT)
			tween.tween_property(efecto, "global_position:y", target.enemy.effect_status.global_position.y, 0.25).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC).set_delay(0.25)
			await tween.finished
			get_tree().root.get_child(0).remove_child(efecto)
			target.enemy.effect_status.add_child(efecto)




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_wwwwwwwwwwwwwwwwwwwwwwwwdelta: float) -> void:
	pass
