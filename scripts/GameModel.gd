extends Node
class_name GameModel

export(int) var balance = 100
export(float) var client_statisfaction = 0
export(int) var passedDays = 0

export(Array) var employees = []

func doSalaryPayment() -> void:
	for employee in employees:
		balance -= employee.salaryPerDay
