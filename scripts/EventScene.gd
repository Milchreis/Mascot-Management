extends Control

signal accept(event)

var event:Event

func _ready():
	if !event: return
	
	find_node("title").text = event.title
	find_node("description").text = event.description
	find_node("costs").text = str(event.costs, "/DAY")
	find_node("duration").text = str(event.duration, " DAYS")

func onAccept():
	emit_signal("accept", event)
