extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_iniciar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/mainmenu.tscn")


func _on_areabinbario_mouse_entered() -> void:
	$"Camera2D/Main Menu/binario/Tooltip".visible = true


func _on_areabinbario_mouse_exited() -> void:
	$"Camera2D/Main Menu/binario/Tooltip".visible = false


func _on_areaamargo_y_retruco_mouse_entered() -> void:
	$"Camera2D/Main Menu/amargo_y_retruco/Tooltip".visible = true


func _on_areaamargo_y_retruco_mouse_exited() -> void:
	$"Camera2D/Main Menu/amargo_y_retruco/Tooltip".visible = false


func _on_areaacapella_mouse_entered() -> void:
	$"Camera2D/Main Menu/acapella/Tooltip".visible = true


func _on_areaacapella_mouse_exited() -> void:
	$"Camera2D/Main Menu/acapella/Tooltip".visible = false
