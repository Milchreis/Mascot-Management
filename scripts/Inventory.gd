extends Control
signal select(mascot)

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel

func onOpen():
	onClose()
	updateUI()
	
func onClose():
	for polaroid in $HScroller.getItems():
		polaroid.disconnect("select", self, "onSelect")
		polaroid.queue_free()
		$HScroller.removeItem(polaroid)

func updateUI():
	for employee in model.employees:
		var polaroid = Polaroid.instance()
		polaroid.mascot = employee
		polaroid.showStats = false
		polaroid.connect("select", self, "onSelect")
		$HScroller.addItem(polaroid)
		
	$noEmployees.visible = model.employees.size() == 0

func onSelect(mascot:Mascot):
	$ClickPlayer.play()
	print("open details for ", mascot._to_string())
	emit_signal("select", mascot)
