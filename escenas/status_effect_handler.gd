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
		GD.fire:[P.first, func(e1,e2):target.change_health(-10, GD.element_colors[GD.fire])],
		GD.water:[P.second, func(e1,e2):target.smoke()],
		GD.root:[P.first, func(e1,e2):pass ], # TODO BURNING
		GD.lightning:[P.both, func(e1,e2):pass ], 
		GD.poison:[P.neither, func(e1,e2):pass ], 
		GD.beer:[P.first, func(e1,e2):pass ], #TODO BURNING 
	},
	GD.water: {
		GD.fire:[P.first, func(e1,e2):target.smoke()],
		GD.water:[P.first, func(e1,e2):target.heal_by(10)],
		GD.root:[P.second, func(e1,e2):target.add_shield(15) ], 
		GD.lightning:[P.first, func(e1,e2):target.change_health(-10, GD.element_colors[GD.lightning]) ], 
		GD.poison:[P.second, func(e1,e2):pass ], #TODO DILUTE
		GD.beer:[P.both, func(e1,e2):pass ], 
	},
	GD.root: {
		GD.fire:[P.second, func(e1,e2):pass ], # TODO BURNING,
		GD.water:[P.first, func(e1,e2):target.add_shield(15) ], 
		GD.root:[P.first, func(e1,e2):pass ],
		GD.lightning:[P.both, func(e1,e2):pass ], 
		GD.poison:[P.both, func(e1,e2):pass ],
		GD.beer:[P.second, func(e1,e2):pass ], 
	},
	GD.lightning: {
		GD.fire:[P.both, func(e1,e2):pass ], 
		GD.water:[P.second, func(e1,e2):target.change_health(-10, GD.element_colors[GD.lightning]) ],
		GD.root:[P.both, func(e1,e2):pass ], 
		GD.lightning:[P.first, func(e1,e2):target.enemy.change_health(-10, GD.element_colors[GD.lightning]) ], 
		GD.poison:[P.neither, func(e1,e2):pass ], 
		GD.beer:[P.second, func(e1,e2):pass ], #TODO burning TODO CONVERT INTO FIRE
	},
	GD.poison: {
		GD.fire:[P.neither, func(e1,e2):pass ], 
		GD.water:[P.first, func(e1,e2):pass ], #TODO DILUTE
		GD.root:[P.both, func(e1,e2):pass ],
		GD.lightning:[P.neither, func(e1,e2):pass ], 
		GD.poison:[P.first, func(e1,e2):pass ], #TODO concentrate
		GD.beer:[P.both, func(e1,e2):pass ],
	},
	GD.beer: {
		GD.fire:[P.second, func(e1,e2):pass ], #TODO BURNING 
		GD.water:[P.both, func(e1,e2):pass ], 
		GD.root:[P.first, func(e1,e2):pass ], 
		GD.lightning:[P.first, func(e1,e2):pass ], #TODO burning TODO CONVERT INTO FIRE
		GD.poison:[P.both, func(e1,e2):pass ],
		GD.beer:[P.first, func(e1,e2):pass ], #TODO CONVERT TO POISON
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
			GD.fire, GD.root, GD.lightning, GD.beer:
				pass
			GD.poison:
				target.deal_poison_damage(efecto.potency)
				await efecto.animate_trigger(0.3)
			GD.water:
				target.heal_by(3)
				await efecto.animate_trigger(0.3)
	

func has_effects_to_run():
	var efectos = await _get_effect_list()
	for efecto in efectos:
		match efecto.type:
			GD.fire, GD.root, GD.lightning, GD.beer:
				pass
			GD.poison, GD.water:
				return true
	return false

func add_effect(sprite, duration = 0, potency = 0):
	var neweffect = StatusEffect.new()
	var image  = Image.load_from_file(sprite)
	if not image or image.is_empty():
		print("imagen noc argo", sprite)
	neweffect.texture = ImageTexture.create_from_image(image)
	neweffect.name = sprite.split("/")[-1].split(".")[0]
	neweffect.type = sprite
	neweffect.duration = duration
	neweffect.potency = potency
	add_child(neweffect)
	

func trigger_effect_collisions():
	print("  triggering effect collisions for ", target.name)
	var efectos = await _get_effect_list()
	var i = 0
	while i < efectos.size()-1:
		var next_reaction_type = reaction_data[efectos[i].type][efectos[i+1].type][0]
		var next_reaction_effect = reaction_data[efectos[i].type][efectos[i+1].type][1]
		match next_reaction_type:
			P.neither, P.first, P.second:
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
			self.remove_child(efecto)
			target.enemy.effect_status.add_child(efecto)
			print("  (from wind)")




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
