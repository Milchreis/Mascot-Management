extends Control

signal close
signal accept(event, mascot)

var Polaroid = preload("res://scenes/Polaroid.tscn")
var EventScene = preload("res://scenes/Event.tscn")

var model:GameModel
var employee:Mascot
var polaroid:Node

func onOpen(mascot:Mascot):
	employee = mascot
	polaroid = Polaroid.instance()
	polaroid.mascot = mascot
	polaroid.showHover = false
	polaroid.clickable = false
	polaroid.rect_position = Vector2(4, 3)
	$LeftSideBackground.add_child(polaroid)
	
	model.connect("day_passed", self, "updateUI")
	employee.connect("trainingDone", self, "onTrainingDone")
	
	reloadEvents()
	updateUI()
	$HScroller.reset()

func onClose():
	model.disconnect("day_passed", self, "updateUI")
	if employee: employee.disconnect("trainingDone", self, "onTrainingDone")
	
	if polaroid:
		$LeftSideBackground.remove_child(polaroid)

func onTrainingDone():
	polaroid.onTrainingDone()

func onAccept(eventScene:EventScene):
	eventScene.connect("animationFinished", self, "reloadEvents")
	eventScene.connect("animationFinished", self, "updateUI")

	if employee.isOuccupied(): $TodoPlayer.play()
	else: $ClickPlayer.play()
	
	if employee.currentEvent == null:
		$HScroller.reset()
		onSlide()
	
	employee.addEvent(eventScene.event)
	model.openEvents.erase(eventScene.event)
	
	emit_signal("accept", eventScene.event, employee)

func onTraining():
	$ClickPlayer.play()
	SlideUtil.jumpControl(self, $Train).connect("finished", self, "updateUI")
	model.startTraining(employee)
	emit_signal("accept", null, employee)

func onFire():
	model.fire(employee)
	SlideUtil.jumpControl(self, $Fire).connect("finished", self, "sendCloseSignal")
	$FirePlayer.play()
	emit_signal("accept", null, employee)

func sendCloseSignal():
	emit_signal("close")

func addEventScene(event:Event):
	var eventScene = EventScene.instance()
	eventScene.event = event
	eventScene.connect("accept", self, "onAccept")
	$HScroller.addItem(eventScene)
	return eventScene

func reloadEvents():
	for node in $HScroller.getItems():
		$HScroller.removeItem(node)
	
	if !employee: return
	
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
			eventScene.find_node("state_label").text = "NEXT #" + str(c)
			c+=1
		
		for event in model.openEvents:
			addEventScene(event)

func updateUI():
	if !employee: return
	
	$Train.visible = !employee.isOuccupied()
	$Train.disabled = employee.training_price > model.balance
	$Train.text = "TRAINING (" + str(employee.training_duration) + "d" + " - " + str(employee.training_price) + "$)"
	
	$Fire.visible = !employee.isOuccupied()
	$AtWorkLabel.visible = employee.isInEvent()
	$AtTrainingLabel.visible = employee.in_training
	$Ill.visible = employee.is_ill
	$ClientSatisfaction/Background/Progess.value = employee.client_satisfaction
	$HScroller.visible = !employee.is_ill
	
	for node in $HScroller.getItems():
		node.find_node("AcceptBtn").visible = !employee.hasEvent(node.event)

func onSlide():
	SlideUtil.jumpControl(self, $HScroller/SlideRightBtn)
	SlideUtil.slideInScrollContainer(self, $HScroller/ScrollContainer, 0, 0.4)
