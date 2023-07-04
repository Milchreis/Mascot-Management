extends Control

var mascot:Mascot

func _ready():
	print("created")
	$pic/Sprite.texture = load(mascot.spriteImage)
