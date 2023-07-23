class_name Event
extends Resource

var id:int
var title:String
var description:String
var property:String
var duration:int
var costs:int

func _init(_id, parts):
	id = _id
	title = parts[0]
	description = parts[1]
	property = parts[2]
	duration = int(parts[3])
	costs = int(parts[4])

func _to_string():
	return (
	"id="+str(id) +
	", title="+title +
	", description="+str(description) +
	", property="+str(property) + 
	", duration="+str(duration) +
	", costs="+str(costs))
