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
	if employee.isInEvent(): $TodoPlayer.play()
	else: $ClickPlayer.play()
	
	if employee.currentEvent == null:
		$Events.scroll_vertical = 0
			
	employee.addEvent(event)
	model.openEvents.erase(event)
	reloadEvents()
	updateUI()
	
func onTraining():
	$ClickPlayer.play()
	model.startTraining(employee)
	updateUI()

func onFire():
	model.fire(employee)
	$FirePlayer.play()
	emit_signal("close")

func addEventScene(event:Event):
	var eventScene = EventScene.instance()
	eventScene.event = event
	eventScene.connect("accept", self, "onAccept")
	$Events/Wrapper.add_child(eventScene)
	return eventScene

func reloadEvents():
	for node in $Events/Wrapper.get_children():
		$Events/Wrapper.remove_child(node)
	
	if !employee.is_ill:
		if employee.isInEvent():
			var eventScene = addEventScene(employee.currentEvent)
			eventScene.find_node("AcceptBtn").visible = false
			eventScene.find_node("state_label").visible = true
			eventScene.find_node("state_label").text = "ACTIVE"
		
		var c=1
		for event in employee.eventWaitlist:
			var eventScene = addEventScene(event)
			eventScene.find_node("AcceptBtn").visible = false
			eventScene.find_node("state_label").visible = true
			eventScene.find_node("state_label").text = "TODO #" + str(c)
			c+=1
		
		for event in model.openEvents:
			addEventScene(event)

func updateUI():
	$Train.visible = !employee.isOuccupied()
	$Fire.visible = !employee.isOuccupied()
	$AtWorkLabel.visible = employee.isInEvent()
	$AtTrainingLabel.visible = employee.in_training
	$Ill.visible = employee.is_ill
	$ClientSatisfaction/Background/Progess.value = employee.client_satisfaction
	$Events.visible = !employee.is_ill
		
	for node in $Events/Wrapper.get_children():
		node.find_node("AcceptBtn").visible = !employee.hasEvent(node.event)
