class_name GameModel
extends Node

signal day_passed

export(int) var balance = 500
export(int) var passedDays = 0
export(float) var dayDurationInSeconds = 10.0

export(Array) var employees = []

var openEvents = []
var applicants = []
var dayTimer := Timer.new()

func _reset():
	balance = 500
	passedDays = 0
	employees = []
	openEvents = []
	createRandomEvents(3)
	dayTimer.start()

func loadSavegame(resource:SaveGame):
	balance = resource.balance
	passedDays = resource.passedDays
	dayDurationInSeconds = resource.dayDurationInSeconds
	employees = resource.employees
	openEvents = resource.openEvents
	applicants = resource.applicants

func _ready() -> void:
	dayTimer.connect("timeout", self, "onDayIsOver")
	dayTimer.autostart = true
	dayTimer.wait_time = dayDurationInSeconds
	add_child(dayTimer)
	createRandomEvents(5)

func increaseApplicantsPool(size=3) -> void:
	for _i in range(0, size):
		applicants.append(createMascot())

func createRandomEvents(amount=1):
	for n in range(0, amount):
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

func createMascot() -> Mascot:
	randomize()
	return Mascot.new()
