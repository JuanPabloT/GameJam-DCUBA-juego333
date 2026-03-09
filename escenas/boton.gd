@tool
extends Button

var is_button_down = false
var is_mouse_inside = false
var real_texture = self.icon
@export var down_texture : Texture2D
@export var hover_texture : Texture2D
@export var size_down : int
@export var label_text : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label.text = label_text
	$Label.resized.connect(_on_label_resized)
	_on_label_resized()

func _on_label_resized() -> void:
	# gpteado, no lo revisé
		var font = $Label.get_theme_font("font")
		var current_size = $Label.get_theme_font_size("font_size")
		
		while font.get_string_size($Label.text, HORIZONTAL_ALIGNMENT_LEFT, -1, current_size).x > $Label.size.x:
			current_size -= 1
			if current_size <= 1:
				break
			$Label.add_theme_font_size_override("font_size", current_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	modulate = Color(1,1,1,1)
	if Engine.is_editor_hint():
		$Label.text = label_text
		_on_label_resized()
		
		


func _on_button_down() -> void:
	$AudioStreamPlayerDown.play()
	$Label.position.y+=size_down
	is_button_down = true 
	icon = down_texture
	
	

func _on_button_up() -> void:
	$AudioStreamPlayerUp.play()
	$Label.position.y-=size_down
	is_button_down = false
	if is_mouse_inside:
		icon = hover_texture
	else:
		icon = real_texture
	 


func _on_mouse_entered() -> void:
	is_mouse_inside=true
	if not is_button_down:
		icon = hover_texture


func _on_mouse_exited() -> void:
	is_mouse_inside=false
	if not is_button_down:
		icon = real_texture
		
