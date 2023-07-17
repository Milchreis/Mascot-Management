extends Control
class_name JobApplication

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var applicants:Array = []

var lastHired = null

func _process(_delta):
	$noApplicants.visible = applicants.size() == 0

func onOpen():
	onClose()
	for polaroid in applicants:
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector/GridContainer.add_child(polaroid)
	
func onClose():
	for polaroid in $PolaroidSelector/GridContainer.get_children():
		polaroid.disconnect("select", self, "onHire")

func createPool(size=3) -> void:
	for _i in range(0, size):
		var polaroid = Polaroid.instance()
		polaroid.mascot = createMascot()
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector/GridContainer.add_child(polaroid)
		applicants.append(polaroid)

func onHire(mascot:Mascot):
	print("hire ", mascot._to_string())
	$HirePlayer.play()
	
	model.employees.append(mascot)
	for application in applicants:
		if application.mascot == mascot:
			lastHired = application
			create_tween() \
				.set_trans(Tween.TRANS_CUBIC) \
				.set_ease(Tween.EASE_OUT) \
				.tween_property(application, "rect_position", Vector2(240, 0), 0.4) \
				.connect("finished", self, "clearLastHired")

func clearLastHired():
	if lastHired == null: return
	
	applicants.erase(lastHired)
	$PolaroidSelector/GridContainer.remove_child(lastHired)
	lastHired = null

func createMascot() -> Mascot:
	randomize()
	return Mascot.new()
