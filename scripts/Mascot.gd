extends Node
class_name Mascot

signal eventDone(event)

var RandomNames = load("res://scripts/random_names.gd").new()
var sprites = [
	"res://gfx/mascots/ape1.png",
	"res://gfx/mascots/dog1.png",
	"res://gfx/mascots/chick1.png"	
]

var bg_colors = ["#7be1f6", "#ffe3ae", "#cdbbab", "#b0d07e", "#ffbae1"]

export var nickname:String = RandomNames.get_first_name()

export var improvisation:float = rand_range(0.0, 5.0)
export var reliable:float = rand_range(0.0, 5.0)
export var charisma:float = rand_range(0.0, 5.0)

export var salaryPerDay:int = rand_range(10, 50)
export var spriteImage:String = sprites[randi() % sprites.size()]
export var bgColor:String = bg_colors[randi() % bg_colors.size()]

var client_satisfaction := 0.0
var jobs := 0

var currentEvent:Event = null
var daysAtCurrentEvent := 0

var in_training := false
var in_training_days := 0
var training_price := 50
var training_duration := 1

# TODO: 
#  - salary depending on properties

func isInEvent() -> bool:
	return currentEvent != null

func start(event:Event) -> void:
	currentEvent = event

func updateAfterDayPassed() -> void:
	if in_training: _updateTraining()
	if isInEvent(): _updateWork()

func _updateWork() -> void:
	if daysAtCurrentEvent == currentEvent.duration:
		print("Work ended for ", nickname, " after ", daysAtCurrentEvent)
		
		if "Charisma" in currentEvent.property:
			client_satisfaction += rand_range(0.05, 0.1)
		
		if "Improvisation" in currentEvent.property:
			client_satisfaction += rand_range(0.05, 0.1)
		
		jobs += 1
		var e = currentEvent
		currentEvent = null
		daysAtCurrentEvent = 0
		emit_signal("eventDone", e)
	
	else:	
		daysAtCurrentEvent += 1

func startTraining() -> void:
	print("Training started for ", nickname)
	in_training = true

func _updateTraining() -> void:
	if in_training == false: return
	in_training_days+=1
	
	if in_training_days > training_duration:
		print("Training ended for ", nickname)
		in_training = false
		in_training_days = 0
		
		reliable = min(reliable + rand_range(0.0, 1.0), 5)
		improvisation = min(improvisation + rand_range(0.0, 1.0), 5)
		charisma = min(charisma + rand_range(0.0, 1.0), 5)

func getRemainingDays():
	if in_training:
		return training_duration - in_training_days
	if isInEvent():
		return currentEvent.duration - daysAtCurrentEvent

func _to_string() -> String:
	return (
		"nickname="+nickname +
		", improvisation="+str(improvisation) +
		", raliable="+str(reliable) + 
		", charisma="+str(charisma)+
		", salaryPerDay="+str(salaryPerDay))
