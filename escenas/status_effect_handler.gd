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

# otra vez, esto deberia ser un recurso, no undiccionario. creo
var reaction_data = {
	GD.fire: {
		GD.fire:[P.first, func(e1,e2):target.change_health(-10, GD.element_colors[GD.fire])],
		GD.water:[P.second, func(e1,e2):pass], #TODO SMOKE
		GD.root:[P.first, func(e1,e2):pass ], # TODO BURNING
		GD.lightning:[P.both, func(e1,e2):pass ], 
		GD.poison:[P.neither, func(e1,e2):pass ], 
		GD.beer:[P.first, func(e1,e2):pass ], #TODO BURNING 
	},
	GD.water: {
		GD.fire:[P.first, func(e1,e2):pass],
		GD.water:[P.first, func(e1,e2):target.heal_by(10)],
		GD.root:[P.second, func(e1,e2):pass ], # TODO SHIELD
		GD.lightning:[P.first, func(e1,e2):target.change_health(-10, GD.element_colors[GD.lightning]) ], 
		GD.poison:[P.second, func(e1,e2):pass ], #TODO DILUTE
		GD.beer:[P.both, func(e1,e2):pass ], 
	},
	GD.root: {
		GD.fire:[P.second, func(e1,e2):pass ], # TODO BURNING,
		GD.water:[P.first, func(e1,e2):pass ], # TODO SHIELD
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
	trigger_effect_collisions()
	

func trigger_effect_collisions():
	var efectos: Array[StatusEffect] 
	efectos.assign(get_children()) 
	var i = 0
	print("collision trigger called")
	while i < efectos.size()-1:
		print(i)
		var next_reaction_type = reaction_data[efectos[i].type][efectos[i+1].type][0]
		var next_reaction_effect = reaction_data[efectos[i].type][efectos[i+1].type][1]
		match next_reaction_type:
			P.neither, P.first, P.second:
				efectos[i].animate_merge(0.5)
				efectos[i+1].animate_merge(0.5)
				await get_tree().create_timer(0.5).timeout
			P.both:
				pass
		next_reaction_effect.call(efectos[i], efectos[i+1])
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
	pass



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
