extends Control

signal close
signal accept(event, mascot)

var Polaroid = preload("res://scenes/Polaroid.tscn")
var EventScene = preload("res://scenes/Event.tscn")

var model:GameModel
var employee:Mascot
var polaroid:Node

var slideOffset := 0
var slideStep := 148

func _process(delta):
	if !employee: return
	$SlideLeftBtn.visible = slideOffset > 0
	$SlideRightBtn.visible = slideOffset < getMaxScroll() - slideStep-4

func onOpen(mascot:Mascot):
	slideOffset = 0
	employee = mascot
	polaroid = Polaroid.instance()
	polaroid.mascot = mascot
	polaroid.showHover = false
	polaroid.clickable = false
	polaroid.rect_position = Vector2(4, 3)
	add_child(polaroid)
	
	model.connect("day_passed", self, "updateUI")
	
	reloadEvents()
	updateUI()

func onClose():
	model.disconnect("day_passed", self, "updateUI")
	
	if polaroid:
		remove_child(polaroid)

func onAccept(eventScene:EventScene):
	eventScene.connect("animationFinished", self, "reloadEvents")
	eventScene.connect("animationFinished", self, "updateUI")

	if employee.isOuccupied(): $TodoPlayer.play()
	else: $ClickPlayer.play()
	
	if employee.currentEvent == null:
		slideOffset = 0
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
	$ScrollContainer/Container.add_child(eventScene)
	return eventScene

func reloadEvents():
	for node in $ScrollContainer/Container.get_children():
		$ScrollContainer/Container.remove_child(node)
	
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
			eventScene.find_node("state_label").text = "TODO #" + str(c)
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
	
	$ScrollContainer/Container.visible = !employee.is_ill
	$SlideRightBtn.visible = !employee.is_ill
	$SlideLeftBtn.visible = !employee.is_ill
	$ColorRect.visible = !employee.is_ill
		
	for node in $ScrollContainer/Container.get_children():
		node.find_node("AcceptBtn").visible = !employee.hasEvent(node.event)

func onSlide():
	SlideUtil.jumpControl(self, $SlideRightBtn)
	SlideUtil.slideInScrollContainer(self, $ScrollContainer, 0, 0.4)
	
func onSlideRight():
	if slideOffset == getMaxScroll(): return
	
	var totalEvents = model.openEvents.size() + employee.amountOfUpcomingEvents()
	var gap = 4
	var maxScroll = slideStep * totalEvents + gap
	
	slideOffset = min(maxScroll, slideOffset + slideStep + gap)
	
	print(slideOffset, " ", gap, " ", maxScroll)
	$ClickPlayer.pitch_scale = 1.0
	$ClickPlayer.play()
	
	SlideUtil.jumpControl(self, $SlideRightBtn)
	SlideUtil.slideInScrollContainer(self, $ScrollContainer, slideOffset, 0.4)

func onSlideLeft():
	if slideOffset == 0: return
	
	var gap = 4
	slideOffset = max(0, slideOffset - slideStep - gap)
	
	$ClickPlayer.pitch_scale = 2.0
	$ClickPlayer.play()
	
	SlideUtil.jumpControl(self, $SlideLeftBtn)
	SlideUtil.slideInScrollContainer(self, $ScrollContainer, slideOffset, 0.4)

func getMaxScroll() -> int:
	var totalEvents = model.openEvents.size() + employee.amountOfUpcomingEvents()
	var gap = 4 * totalEvents
	return slideStep * totalEvents + gap
