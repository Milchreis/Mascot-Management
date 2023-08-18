class_name EventScene
extends Control

signal accept(eventScene)
signal animationFinished

var event:Event

func _ready():
	if !event: return
	
	find_node("title").text = event.title
	find_node("description").text = event.description
	find_node("costs").text = str(event.costs, "$/d")
	find_node("duration").text = str(event.duration, " DAYS")

func onAccept():
	SlideUtil.jumpControl(self, $VBoxContainer/HBoxContainer/AcceptBtn)\
	.connect("finished", self, "onAcceptAnimationFinished")
	
	emit_signal("accept", self)

func onAcceptAnimationFinished():
	emit_signal("animationFinished")
