extends Node

var pagina : int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pagina = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	pagina += 1
	match pagina:
		1:
			$"Camera2D/Main Menu/pj".rotation = 0
			$"Camera2D/Main Menu/gaucho".position = Vector2(950, 300)
			$"Camera2D/Main Menu/UiBoardSmallParchment/Label".text = "Mira que ya se van todos"
		2:
			$"Camera2D/Main Menu/UiBoardSmallParchment/Label".text = "La noche de juegos ya\ntermino"
		3:
			$"Camera2D/Main Menu/UiBoardSmallParchment/Label".text = "Anda a casa que hay que\n
			preparar finales."
		4:
			get_tree().change_scene_to_file("res://escenas/victoria_torneo.tscn")
