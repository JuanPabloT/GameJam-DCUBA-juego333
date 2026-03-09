extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in $Camera2D/background.get_children():
		child.modulate = Color(1,1,1,0.5)
	if GameData.logro_max_hp:
		$Camera2D/background/LogroHP.modulate=Color(1,1,1,1)
	if GameData.todas_partes_artefactos:
		$Camera2D/background/LogroArtef.modulate=Color(1,1,1,1)
	if GameData.matar_bruja_veneno:
		$Camera2D/background/LogroBruja.modulate=Color(1,1,1,1)
	if GameData.matar_elemental_quemandolo:
		$Camera2D/background/LogroElemental.modulate=Color(1,1,1,1)
	if GameData.danio_60_de_una:
		$Camera2D/background/Logro60.modulate=Color(1,1,1,1)
	if GameData.reaccionar_5_turno:
		$Camera2D/background/LogroReac.modulate=Color(1,1,1,1)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")
