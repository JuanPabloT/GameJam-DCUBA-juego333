extends Node2D
var imageup
var imagedown
var imageright
var game_manager = owner # no funca?

func setup(iu,id,ir,gm):
	imageup = iu
	imagedown = id
	imageright = ir
	game_manager = gm


func use_on(target):
	#TODO animacion de uso, basandose en posicion de target
	game_manager.real_effects[imageup].call(target)
	game_manager.real_effects[imagedown].call(target)
	game_manager.real_effects[imageright].call(target)
	self.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	$Up.texture = ImageTexture.create_from_image(Image.load_from_file(imageup))
	$Down.texture = ImageTexture.create_from_image(Image.load_from_file(imagedown))
	$Right.texture = ImageTexture.create_from_image(Image.load_from_file(imageright))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
