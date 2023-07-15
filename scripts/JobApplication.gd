extends Control
class_name JobApplication

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var applications:Array = []

var lastHired = null

func onOpen():
	for i in range(0, applications.size()):
		var polaroid = applications[i]
		var gap = 15
		polaroid.rect_position.x = i * (polaroid.rect_size.x + gap)
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector.add_child(polaroid)
	
func onClose():
	for polaroid in $PolaroidSelector.get_children():
		polaroid.disconnect("select", self, "onHire")

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
			lastHired = application
			var tween := create_tween() \
				.set_trans(Tween.TRANS_CUBIC) \
				.set_ease(Tween.EASE_OUT) \
				.tween_property(application, "rect_position", Vector2(240, 0), 0.4) \
				.connect("finished", self, "clearLastHired")

func clearLastHired():
	if lastHired == null: return
	
	applications.erase(lastHired)
	$PolaroidSelector.remove_child(lastHired)
	lastHired = null

func createMascot() -> Mascot:
	randomize()
	return Mascot.new()
