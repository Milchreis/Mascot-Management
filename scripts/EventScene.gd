extends Control

var event:Event

func _ready():
	find_node("title").text = event.title
	find_node("description").text = event.description
	find_node("costs").text = str(event.costs, "/DAY")
	find_node("duration").text = str(event.duration, " DAYS")
