extends Control
signal select(mascot)

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel

var slideOffset := 0
var slideStep := 65

func onOpen():
	onClose()
	updateUI()
	
func onClose():
	for polaroid in $ScrollContainer/Container.get_children():
		polaroid.disconnect("select", self, "onSelect")
		polaroid.queue_free()
		$ScrollContainer/Container.remove_child(polaroid)

func _process(delta):
	$SlideLeftBtn.visible = slideOffset < 0
	$SlideRightBtn.visible = slideStep*3 < slideStep * model.employees.size() \
		and -slideOffset+(3*slideStep) < slideStep * model.employees.size()

func updateUI():
	for employee in model.employees:
		var polaroid = Polaroid.instance()
		polaroid.mascot = employee
		polaroid.showStats = false
		polaroid.connect("select", self, "onSelect")
		$ScrollContainer/Container.add_child(polaroid)
		
	$noEmployees.visible = model.employees.size() == 0

func onSelect(mascot:Mascot):
	$ClickPlayer.play()
	print("open details for ", mascot._to_string())
	emit_signal("select", mascot)

func onSlideRight():
	var node := $ScrollContainer/Container
	slideOffset -= slideStep
	$ClickPlayer.pitch_scale = 1.0
	$ClickPlayer.play()
	SlideUtil.jumpControl(self, $SlideRightBtn)
	SlideUtil.slideControl(self, node, \
		node.rect_position, \
		Vector2(slideOffset, node.rect_position.y), \
		0.4)

func onSlideLeft():
	var node := $ScrollContainer/Container
	slideOffset += slideStep
	$ClickPlayer.pitch_scale = 2.0
	$ClickPlayer.play()
	SlideUtil.jumpControl(self, $SlideLeftBtn)
	SlideUtil.slideControl(self, node, \
		node.rect_position, \
		Vector2(slideOffset, node.rect_position.y), \
		0.4)
