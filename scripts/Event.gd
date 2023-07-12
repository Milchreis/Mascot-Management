class_name Event

var title:String
var description:String
var property:String
var duration:int
var costs:int

func _init(parts):
	title = parts[0]
	description = parts[1]
	property = parts[2]
	duration = int(parts[3])
	costs = int(parts[4])

func _to_string():
	return (
	"title="+title +
	", description="+str(description) +
	", property="+str(property) + 
	", duration="+str(duration)+
	", costs="+str(costs))
