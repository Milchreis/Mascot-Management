extends Control
class_name JobApplication

signal hired(mascot)

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
		$HScroller.addItem(polaroid)
	
func onClose():
	for polaroid in $HScroller.getItems():
		polaroid.disconnect("select", self, "onHire")
		$HScroller.removeItem(polaroid)

func reset():
	lastHired = []

func updateUI():
	var polaroidNodes = $HScroller.getItems()
	
	var availableMascots = []
	for polaroid in polaroidNodes:
		availableMascots.append(polaroid.mascot)
	
	for mascot in model.applicants:
		if !availableMascots.has(mascot):
			var polaroid = Polaroid.instance()
			polaroid.mascot = mascot
			polaroid.connect("select", self, "onHire")
			$HScroller.addItem(polaroid)

func onHire(mascot:Mascot):
	print("hire ", mascot._to_string())
	$HirePlayer.play()
	
	model.employees.append(mascot)
	
	for polaroid in $HScroller.getItems():
		if polaroid.mascot == mascot:
			polaroid.clickable = false
			lastHired.append(polaroid)
		
			var x = polaroid.rect_position.x
			var y = polaroid.rect_position.y
		
			var tween = create_tween() \
				.set_trans(Tween.TRANS_CUBIC) \
				.set_ease(Tween.EASE_OUT) \
				
			tween.connect("finished", self, "clearLastHired")
			tween.tween_property(polaroid, "rect_position", Vector2(x, y-10), 0.2)
			tween.tween_property(polaroid, "rect_position", Vector2(x, y), 0.2)
			tween.parallel().tween_property(polaroid, "rect_global_position", Vector2(240, 23), 0.4)

func clearLastHired():
	if lastHired.empty(): return
	
	for polaroid in lastHired:
		emit_signal("hired", polaroid.mascot)
		model.applicants.erase(polaroid.mascot)
		$HScroller.removeItem(polaroid)
		lastHired.erase(polaroid)
