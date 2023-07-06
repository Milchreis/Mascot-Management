extends Node2D

var GameModel = load("res://scripts/GameModel.gd")
var model:GameModel = GameModel.new()

onready var start_time = OS.get_ticks_msec()

func _ready():
	$Desk.model = model
	$Desk/JobApplication.model = model
	
	$Desk/JobApplication.createPool(1)

func _process(_delta):
	if model.client_statisfaction < 100.0: 
		model.client_statisfaction += 0.1
	
func onDayIsOver() -> void:
	model.passedDays+=1
	print("Days over " + str(model.passedDays))
	model.doSalaryPayment()
	
func getDayProgress() -> float:
	return 1 - ($DayTimer.time_left / $DayTimer.wait_time)
