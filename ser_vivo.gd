@abstract class_name SerVivo
extends Node


var health
@export var health_status : Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func is_dead()->bool:
	return health <= 0

func change_health(amount:int):
	if health_status != null:
		health_status.text = str(health)
	health += amount
	
	if is_dead():
		on_death()
		
@abstract func on_death()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
