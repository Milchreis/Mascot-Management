class_name Mascot

signal eventDone(event)

var RandomNames = load("res://scripts/random_names.gd").new()
var spriteIndex = randi() % 40

export var nickname:String = RandomNames.get_first_name()

export var improvisation:float = rand_range(0.0, 3.0)
export var reliable:float = rand_range(0.0, 3.0)
export var charisma:float = rand_range(0.0, 3.0)

export var leaveProbability:float = rand_range(0.05, 0.1)
export var sabaticalProbability:float = rand_range(0.0, 0.06)

export var salaryPerDay:int = _calcSalary()
export var client_satisfaction := 0.0
export var jobs := 0

var currentEvent:Event = null
var daysAtCurrentEvent := 0
var eventWaitlist = []
var daysEmployeed := 0

var in_training := false
var in_training_days := 0
var training_price := 50
var training_duration := 1

var is_ill := false
var ill_days_remaining := 3

var leaveCooldownInDays := 6
var illness_decrease_factor := 0.0

func isOuccupied() -> bool:
	return isInEvent() or in_training or is_ill

func _calcIllnessRisk() -> float:
	var unreliable = 1 - (reliable/5)
	var baseIllness = max(0.05 * (1.0 - illness_decrease_factor), 0)
	return baseIllness * unreliable

func _calcSalary() -> int:
	var skill = (improvisation + reliable + charisma) / 3
	var baseSalary = 10.0
	return int(baseSalary*skill)

func isInEvent() -> bool:
	return currentEvent != null

func addEvent(event:Event) -> void:
	if in_training: eventWaitlist.append(event)
	elif currentEvent == null: currentEvent = event
	else: eventWaitlist.append(event)

func updateAfterDayPassed() -> void:
	daysEmployeed += 1
	leaveCooldownInDays = max(leaveCooldownInDays - 1, 0)
	_updateIllness()
	
	if in_training: _updateTraining()
	elif isInEvent(): _updateWork()
	else: 
		_loadEventFromWaitlist()
		client_satisfaction = max(0.0, client_satisfaction - 0.005)

func _updateIllness():
	if is_ill:
		ill_days_remaining -= 1
		is_ill = ill_days_remaining >= 0
	
	elif !in_training and !inSabat() and RandomUtil.withChanceOf(_calcIllnessRisk()):
		is_ill = true
		ill_days_remaining = 3
		if isInEvent():
			print(nickname, " gets ill and is away for ", ill_days_remaining, " days")
			currentEvent = null
			client_satisfaction = max(0.0, client_satisfaction - 0.01)

func inSabat() -> bool:
	return currentEvent != null and currentEvent.isSabat()

func _updateWork() -> void:
	if daysAtCurrentEvent == currentEvent.duration:
		print("Work ended for ", nickname, " after ", daysAtCurrentEvent, " days")
		
		if "Charisma" in currentEvent.property:
			var charismaIncrease = _calcIncrease(charisma)
			client_satisfaction = min(1.0, client_satisfaction + charismaIncrease)
			print("Satisfaction increased by Charisma: ", charismaIncrease)
	
		if "Improvisation" in currentEvent.property:
			var improIncrease = _calcIncrease(improvisation)
			client_satisfaction = min(1.0, client_satisfaction + improIncrease)
			print("Satisfaction increased by Improvisation: ", improIncrease)
		
		if "Reliability" in currentEvent.property:
			var reliableIncrease = _calcIncrease(reliable)
			client_satisfaction = min(1.0, client_satisfaction + reliableIncrease)
			print("Satisfaction increased by Reliability: ", reliableIncrease)
		
		jobs += 1
		var e = currentEvent
		currentEvent = null
		daysAtCurrentEvent = 0
		emit_signal("eventDone", e)
		_loadEventFromWaitlist()
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
		training_duration += 1
		training_price *= 1.25
		leaveCooldownInDays = 6
		
		leaveProbability = min(leaveProbability - 0.02, 0.001)
		reliable = min(reliable + rand_range(0.5, 1.0), 5)
		improvisation = min(improvisation + rand_range(0.5, 1.0), 5)
		charisma = min(charisma + rand_range(0.5, 1.0), 5)
		_loadEventFromWaitlist()

func getBalance() -> int:
	if currentEvent == null: return -salaryPerDay
	else: return -salaryPerDay + currentEvent.costs

func _loadEventFromWaitlist():
	if !in_training and !is_ill and !eventWaitlist.empty():
		daysAtCurrentEvent = 0
		currentEvent = eventWaitlist.pop_front()

func _calcIncrease(property) -> float:
	var normalizedProperty = property/5.0
	return 0.15 * (1+normalizedProperty)

func getRemainingDays():
	if in_training:
		return training_duration - in_training_days
	if isInEvent():
		return currentEvent.duration - daysAtCurrentEvent
	if is_ill:
		return ill_days_remaining

func amountOfUpcomingEvents() -> int:
	if currentEvent: return 1 + eventWaitlist.size()
	else: return eventWaitlist.size()

func hasEvent(event:Event) -> bool:
	return currentEvent == event or eventWaitlist.find(event) != -1

func _to_string() -> String:
	return (
		"nickname="+nickname +
		", improvisation="+str(improvisation) +
		", raliable="+str(reliable) + 
		", charisma="+str(charisma) +
		", salaryPerDay="+str(salaryPerDay) +
		", leaveProbability="+str(leaveProbability) +
		", sabaticalProbability="+str(sabaticalProbability) +
		", client_satisfaction="+str(client_satisfaction) +
		", in_training="+str(in_training) +
		", in_training_days="+str(in_training_days) +
		", training_duration="+str(training_duration) +
		", is_ill="+str(is_ill) +
		", ill_days_remaining="+str(ill_days_remaining))
	
