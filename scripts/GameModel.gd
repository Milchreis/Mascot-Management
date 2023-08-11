class_name GameModel

signal employee_gone(mascot)
signal employee_sabbat(mascot)
signal day_passed

var balance := 100
var passedDays := 0
var dayDurationInSeconds := 10.0

var employees = []
var openEvents = []
var applicants = []

var daysInFullSatisfaction := 0
var daysInFullSatisfactionBest := 0

var dayTimer:Timer

func _init(dayTimer:Timer):
	self.dayTimer = dayTimer
	createRandomEvents(5)
	increaseApplicantsPool(10)

func loadSavegame(resource:SaveGame):
	balance = resource.balance
	passedDays = resource.passedDays
	dayDurationInSeconds = resource.dayDurationInSeconds
	employees = resource.employees
	openEvents = resource.openEvents
	applicants = resource.applicants

func _reset():
	balance = 100
	passedDays = 0
	daysInFullSatisfactionBest = 0
	daysInFullSatisfaction = 0
	employees = []
	openEvents = []
	applicants = []
	createRandomEvents(5)
	increaseApplicantsPool(3)
	dayTimer.start()

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
		
	if RandomUtil.withChanceOf(0.25) and applicants.size() < 20:
		increaseApplicantsPool(2)
		
	if RandomUtil.withChanceOf(0.5) and openEvents.size() <= 3:
		createRandomEvents(5)
		
	if getClientSatisfaction() >= 0.99:
		daysInFullSatisfaction += 1
		daysInFullSatisfactionBest = daysInFullSatisfaction
	else:
		daysInFullSatisfaction = 0
	
	emit_signal("day_passed")

func getDayProgress() -> float:
	return 1 - (dayTimer.time_left / dayTimer.wait_time)

func getClientSatisfaction() -> float:
	var sum:float = 0
	var jobsSum:float = 0.0
	
	for employee in employees: jobsSum += employee.jobs

	for employee in employees:
		if employee.jobs > 0:
			var weight:float = employee.jobs / jobsSum
			sum += employee.client_satisfaction * weight
	
	return sum

func updateEmployees() -> void:
	for employee in employees:
		employee = employee as Mascot
		
		if employee.isInEvent():
			balance += employee.currentEvent.costs
		else:
			if employee.leaveCooldownInDays == 0 and RandomUtil.withChanceOf(employee.leaveProbability):
				employees.erase(employee)
				emit_signal("employee_gone", employee)

			if !employee.is_ill and RandomUtil.withChanceOf(employee.sabaticalProbability):
				employee.currentEvent = Event.new(-1, ["Sabbatical", employee.nickname + " is on a journey to himself to recharge his batteries.", "", 10, employee.salaryPerDay])
				emit_signal("employee_sabbat", employee)
		
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
