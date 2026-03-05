class_name StatusEffect
extends TextureRect

var type : String
var duration = 0
var potency = 0
var label : Label


func animate_merge(time):
	await get_tree().create_timer(0.1).timeout
	var animated_child = TextureRect.new()
	animated_child.texture = self.texture
	self.self_modulate.a=0
	add_child(animated_child)
	var tween = create_tween()
	var cpos = global_position
	var cscale = scale
	
	for i in range(10):
		var offset = Vector2(randf_range(-5, 5), randf_range(-5, 5)).normalized()*5
		tween.tween_property(animated_child, "global_position", cpos + offset, time/10)
	#for i in range(10):
	#	var offset = Vector2(randf_range(-0.1, 0.1), randf_range(-0.1, 0.1))
	#	tween.tween_property(animated_child, "scale", cscale + offset, time/10)
	await tween.finished
	self.self_modulate.a=1
	animated_child.queue_free()
	
func animate_trigger(time):
	var animated_child = self.duplicate()
	add_child(animated_child)
	var tween = create_tween()
	var crotation = rotation
	var cscale = scale
	tween.tween_property(animated_child, "scale", cscale + Vector2(0.1,0.1), time/5)
	tween.tween_property(animated_child, "scale", cscale, 4*time/5) 
		
	await get_tree().create_timer(time).timeout
	animated_child.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.pivot_offset_ratio = Vector2(0.5,0.5)
	if duration>0:
		modulate = Color.DARK_ORANGE
	label = Label.new()
	add_child(label)
	label.add_theme_color_override("font_outline_color",Color("black"))
	label.add_theme_color_override("font_color",Color("white"))
	label.add_theme_constant_override("outline_size", 12)
	label.position = Vector2(35,33)

	
	

func set_duration(n):
	duration = n
	if duration>0:
		modulate = Color.DARK_ORANGE
	else:
		modulate = Color.WHITE

func add_duration(n):
	set_duration(duration+n)

func update_duration():
	duration -= 1
	if duration == 0:
		modulate = Color.WHITE
		return true
	return false

func dilute():
	potency = floor(potency/2)
	
func concentrate(n):
	potency = potency+n
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if duration+potency>0:
		label.text=str(duration+potency)
	else:
		label.text=""
		
