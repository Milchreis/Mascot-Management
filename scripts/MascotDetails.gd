extends Control
signal close

var Polaroid = preload("res://scenes/Polaroid.tscn")
var EventScene = preload("res://scenes/Event.tscn")

var model:GameModel
var employee:Mascot
var polaroid:Node

func _process(_delta):
	if employee:
		$ClientSatisfaction/Background/Progess.value = employee.client_satisfaction

func onOpen(mascot:Mascot):
	employee = mascot
	polaroid = Polaroid.instance()
	polaroid.mascot = mascot
	polaroid.showHover = false
	polaroid.rect_position = Vector2(10, 27)
	add_child(polaroid)
	
	for event in model.openEvents:
		var eventScene = EventScene.instance()
		eventScene.event = event
		$Events/Wrapper.add_child(eventScene)

func onClose():
	if polaroid:
		remove_child(polaroid)

func onTraining():
	model.startTraining(employee)

func onFire():
	model.fire(employee)
	emit_signal("close")
