class_name GameModel

signal employee_gone(mascot)
signal employee_sabat(mascot)

export(int) var balance = 500
export(int) var passedDays = 0
export(float) var dayDurationInSeconds = 10.0

var employees = []
var openEvents = []
var applicants = []

var dayTimer:Timer

func _init(dayTimer:Timer):
	self.dayTimer = dayTimer
	createRandomEvents(5)
	increaseApplicantsPool(3)

func loadSavegame(resource:SaveGame):
	balance = resource.balance
	passedDays = resource.passedDays
	dayDurationInSeconds = resource.dayDurationInSeconds
	employees = resource.employees
	openEvents = resource.openEvents
	applicants = resource.applicants

func _reset():
	balance = 500
	passedDays = 0
	employees = []
	openEvents = []
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
		
	if RandomUtil.withChanceOf(0.1) and applicants.size() < 20:
		increaseApplicantsPool(2)
		
	if RandomUtil.withChanceOf(0.5) and openEvents.size() < 3:
		createRandomEvents(3)
	
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
		employee = employee as Mascot
		
		if employee.isInEvent():
			balance += employee.currentEvent.costs
		else:
			if RandomUtil.withChanceOf(employee.leaveProbability):
				employees.erase(employee)
				emit_signal("employee_gone", employee)

			if RandomUtil.withChanceOf(employee.sabaticalProbability):
				employee.currentEvent = Event.new(-1, ["Sabat", "need some space", "", 10, employee.salaryPerDay])
				emit_signal("employee_sabat", employee)
		
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
