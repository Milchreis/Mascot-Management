extends Control

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel

func onOpen():
	visible = true
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
		$PolaroidList.add_child(polaroid)
	
func onClose():
	visible = false
	for child in $PolaroidList.get_children():
		child.disconnect("select", self, "onSelect")
		child.queue_free()

func onSelect(mascot:Mascot):
	print("open details for ", mascot._to_string())