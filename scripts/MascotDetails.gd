extends Control
signal close

var Polaroid = preload("res://scenes/Polaroid.tscn")
var EventScene = preload("res://scenes/Event.tscn")

var model:GameModel
var employee:Mascot
var polaroid:Node

func onOpen(mascot:Mascot):
	model.connect("day_passed", self, "updateUI")
	model.connect("day_passed", self, "reloadEvents")
	
	employee = mascot
	polaroid = Polaroid.instance()
	polaroid.mascot = mascot
	polaroid.showHover = false
	polaroid.rect_position = Vector2(10, 3)
	add_child(polaroid)
	
	reloadEvents()
	updateUI()

func onClose():
	if polaroid:
		remove_child(polaroid)
	
	model.disconnect("day_passed", self, "updateUI")
	model.disconnect("day_passed", self, "reloadEvents")

func onAccept(event:Event):
	employee.start(event)
	model.openEvents.erase(event)
	print(model.openEvents.size())
	updateUI()
	
	for node in $Events/Wrapper.get_children():
		if node.event != event:
			$Events/Wrapper.remove_child(node)

func onTraining():
	model.startTraining(employee)
	updateUI()

func onFire():
	model.fire(employee)
	emit_signal("close")

func addEventScene(event:Event):
	var eventScene = EventScene.instance()
	eventScene.event = event
	eventScene.connect("accept", self, "onAccept")
	$Events/Wrapper.add_child(eventScene)
	return eventScene

func reloadEvents():
	print("reloadEvents")
	for node in $Events/Wrapper.get_children():
		$Events/Wrapper.remove_child(node)
	
	if employee.isInEvent():
		var eventScene = addEventScene(employee.currentEvent)
		eventScene.find_node("AcceptBtn").visible = false
	else:
		for event in model.openEvents:
			addEventScene(event)

func updateUI():
	$Train.visible = !employee.isInEvent() and !employee.in_training
	$Fire.visible = !employee.isInEvent() and !employee.in_training
	$AtWorkLabel.visible = employee.isInEvent()
	$AtTrainingLabel.visible = employee.in_training
	$ClientSatisfaction/Background/Progess.value = employee.client_satisfaction
	
	for node in $Events/Wrapper.get_children():
		node.find_node("AcceptBtn").visible = node.event != employee.currentEvent
