extends Control

var event:Event

func _ready():
	$title.text = event.title
	$description.text = event.description
	$costs.text = str(event.costs, "/DAY")
	$duration.text = str(event.duration, " DAYS")
