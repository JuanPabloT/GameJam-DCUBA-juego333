extends Node2D
var imageup
var imagedown
var imageright
var initialanimation = true

func setup():
	imageup = GameData.top_artifact_pieces.pick_random()
	imagedown = GameData.bottom_artifact_pieces.pick_random()
	imageright = GameData.side_artifact_pieces.pick_random()
		


func use_on(target):
	#TODO animacion de uso, basandose en posicion de target
	await GameData.real_effects[imageup].call(target)
	await GameData.real_effects[imageright].call(target)
	await GameData.real_effects[imagedown].call(target)
	self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	scale = Vector2(0.3,0.3)
	position.y = 150
	setup()
	$Up.texture = ImageTexture.create_from_image(Image.load_from_file(imageup))
	$Down.texture = ImageTexture.create_from_image(Image.load_from_file(imagedown))
	$Right.texture = ImageTexture.create_from_image(Image.load_from_file(imageright))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if initialanimation:
		position = lerp(position, Vector2(position.x, 0), 0.3)
		if Vector2(position.x, 0).distance_to(position) < 0.1:
			initialanimation = false
