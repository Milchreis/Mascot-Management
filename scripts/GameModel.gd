extends Node
class_name GameModel

export(int) var balance = 100
export(int) var passedDays = 0

export(Array) var employees = []

func getClientSatisfaction() -> float:
	var count:int = 0
	var sum:float = 0
	
	for employee in employees:
		if employee.jobs > 0:
			count += 1
			sum += employee.client_satisfaction
	
	if count == 0: return 0.0
	else: return sum / count

func doSalaryPayment() -> void:
	for employee in employees:
		balance -= employee.salaryPerDay
