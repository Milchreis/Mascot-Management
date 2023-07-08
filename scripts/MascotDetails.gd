extends Control

var Polaroid = preload("res://scenes/Polaroid.tscn")

var model:GameModel
var employee:Mascot

func _process(_delta):
	if employee:
		$ClientSatisfaction/Background/Progess.value = employee.client_satisfaction

func onOpen(mascot:Mascot):
	visible = true
	employee = mascot
	var polaroid = Polaroid.instance()
	polaroid.mascot = mascot
	polaroid.rect_position = Vector2(10, 27)
	add_child(polaroid)

func onClose():
	visible = false

func onTraining():
	pass # Replace with function body.


func onFire():
	pass # Replace with function body.
