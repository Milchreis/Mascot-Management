extends Control
class_name JobApplication

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var applications:Array = []

func _ready():		
	for n in range(0, 3):
		applications.append(createMascot())
	
	for mascot in applications:
		var polaroid = Polaroid.instance()
		polaroid.mascot = mascot
		$PolaroidSelector.add_child(polaroid)

func createMascot() -> Mascot:
	randomize()
	return Mascot.new()
