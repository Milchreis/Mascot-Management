extends Control
signal select(mascot)

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel

func onOpen():
	updateUI()
	
func onClose():
	updateUI()

func updateUI():
	for child in $PolaroidList/GridContainer.get_children():
		child.disconnect("select", self, "onSelect")
		child.queue_free()
	
	for i in range(0, model.employees.size()):
		var employee = model.employees[i]
		var x = i % 4
		var y = i / 4 
		var gap = 15
		var polaroid = Polaroid.instance()
		polaroid.mascot = employee
		polaroid.showStats = false
		polaroid.rect_position.x = x * (polaroid.rect_size.x + gap)
		polaroid.rect_position.y = y * (polaroid.rect_size.y + gap)
		polaroid.connect("select", self, "onSelect")
		$PolaroidList/GridContainer.add_child(polaroid)
		
	$noEmployees.visible = model.employees.size() == 0

func onSelect(mascot:Mascot):
	$ClickPlayer.play()
	print("open details for ", mascot._to_string())
	emit_signal("select", mascot)
