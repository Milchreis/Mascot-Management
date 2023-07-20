extends Node
class_name GameModel

signal day_passed

var RandomEvents = load("res://scripts/random_events.gd").new()

export(int) var balance = 500
export(int) var passedDays = 0
export(float) var dayDurationInSeconds = 10.0

export(Array) var employees = []

var openEvents = []
var dayTimer := Timer.new()

func _reset():
	balance = 500
	passedDays = 0
	employees = []
	openEvents = []
	dayTimer.start()

func _ready() -> void:
	dayTimer.connect("timeout", self, "onDayIsOver")
	dayTimer.autostart = true
	dayTimer.wait_time = dayDurationInSeconds
	add_child(dayTimer)
	
	for n in range(0, 5):
		openEvents.append(RandomEvents.get_random_event())

func onDayIsOver() -> void:
	passedDays+=1
	print("Days over ", passedDays)
	updateEmployees()
	emit_signal("day_passed")
	
func getDayProgress() -> float:
	return 1 - (dayTimer.time_left / dayTimer.wait_time)

func getClientSatisfaction() -> float:
	var count:int = 0
	var sum:float = 0
	
	for employee in employees:
		if employee.jobs > 0:
			count += 1
			sum += employee.client_satisfaction
	
	if count == 0: return 0.0
	else: return sum / count

func updateEmployees() -> void:
	for employee in employees:
		if employee.isInEvent():
			balance += employee.currentEvent.costs
		
		balance -= employee.salaryPerDay
		employee.updateAfterDayPassed()

func fire(mascot:Mascot) -> void:
	employees.erase(mascot)
	balance -= floor(mascot.salaryPerDay * getDayProgress())

func startTraining(mascot:Mascot) -> void:
	mascot.startTraining()
	balance -= mascot.training_price
