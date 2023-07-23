extends Control
class_name JobApplication

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var lastHired = []

func _process(_delta):
	$noApplicants.visible = model.applicants.empty()

func onOpen():
	onClose()
	for applicant in model.applicants:
		var polaroid = Polaroid.instance()
		polaroid.mascot = applicant
		polaroid.connect("select", self, "onHire")
		$PolaroidSelector/GridContainer.add_child(polaroid)
	
func onClose():
	for polaroid in $PolaroidSelector/GridContainer.get_children():
		polaroid.disconnect("select", self, "onHire")

func reset():
	lastHired = []

func onHire(mascot:Mascot):
	print("hire ", mascot._to_string())
	$HirePlayer.play()
	
	model.employees.append(mascot)
	
	for polaroid in $PolaroidSelector/GridContainer.get_children():
		if polaroid.mascot == mascot:
			polaroid.clickable = false
			lastHired.append(polaroid)
		
			create_tween() \
				.set_trans(Tween.TRANS_CUBIC) \
				.set_ease(Tween.EASE_OUT) \
				.tween_property(polaroid, "rect_position", Vector2(240, 0), 0.4) \
				.connect("finished", self, "clearLastHired")

func clearLastHired():
	if lastHired.empty(): return
	
	for polaroid in lastHired:
		model.applicants.erase(polaroid.mascot)
		$PolaroidSelector/GridContainer.remove_child(polaroid)
		lastHired.erase(polaroid)
