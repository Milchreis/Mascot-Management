extends Node
class_name GameModel

var RandomEvents = load("res://scripts/random_events.gd").new()

export(int) var balance = 500
export(int) var passedDays = 0
export(float) var dayDurationInSeconds = 10.0

export(Array) var employees = []

var openEvents = []
var dayTimer := Timer.new()

func _ready() -> void:
	dayTimer.connect("timeout", self, "onDayIsOver")
	dayTimer.autostart = true
	dayTimer.wait_time = dayDurationInSeconds
	add_child(dayTimer)
	
	for n in range(0, 10):
		openEvents.append(RandomEvents.get_random_event())

func onDayIsOver() -> void:
	passedDays+=1
	print("Days over ", passedDays)
	updateEmployees()
	
	
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
		balance -= employee.salaryPerDay
		employee.updateTraining()

func fire(mascot:Mascot) -> void:
	employees.erase(mascot)
	balance -= floor(mascot.salaryPerDay * getDayProgress())

func startTraining(mascot:Mascot) -> void:
	mascot.startTraining()
	balance -= mascot.training_price
