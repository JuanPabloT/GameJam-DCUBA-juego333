class_name StatusEffect
extends TextureRect

var type : String
var duration = 0
var potency = 0

func animate_merge(time):
	var animated_child = self.duplicate()
	add_child(animated_child)
	var tween = create_tween()
	var cpos = position
	var cscale = scale
	# Shake back and forth
	#for i in range(10):
	#	var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5)).normalized()*5
	#	tween.tween_property(animated_child, "position", cpos + offset, time/10)
	for i in range(10):
		var offset = Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
		tween.tween_property(animated_child, "scale", cscale + offset, time/10)
	await get_tree().create_timer(time).timeout
	animated_child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
