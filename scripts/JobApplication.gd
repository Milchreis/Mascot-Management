extends Control
class_name JobApplication

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var applications:Array = []
var isLeft := false
var isRight := true

func onOpen():
	visible = true
	for i in range(0, applications.size()):
		var polaroid = applications[i]
		var gap = 15
		polaroid.rect_position.x = i * (polaroid.rect_size.x + gap)
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector.add_child(polaroid)

	isLeft = false
	
func onClose():
	for polaroid in $PolaroidSelector.get_children():
		polaroid.disconnect("select", self, "onHire")

	isLeft = true
		
func createPool(size=3) -> void:
	for i in range(0, size):
		var gap = 15
		var polaroid = Polaroid.instance()
		polaroid.mascot = createMascot()
		polaroid.rect_position.x = i * (polaroid.rect_size.x + gap)
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector.add_child(polaroid)
		applications.append(polaroid)

func onHire(mascot:Mascot):
	print("hire ", mascot._to_string())
	
	model.employees.append(mascot)
	for application in applications:
		if application.mascot == mascot:
			applications.erase(application)
			$PolaroidSelector.remove_child(application)
	
func createMascot() -> Mascot:
	randomize()
	return Mascot.new()
