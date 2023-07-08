extends Node2D

var GameModel = load("res://scripts/GameModel.gd")
var model:GameModel = GameModel.new()

onready var start_time = OS.get_ticks_msec()

func _ready():
	$Desk.model = model
	$Desk/JobApplication.model = model
	$Desk/Inventory.model = model
	$Desk/MascotDetails.model = model
	
	$Desk/JobApplication.createPool(3)
	onOpenJobApplication()

func _process(_delta):
	pass
	
func onDayIsOver() -> void:
	model.passedDays+=1
	print("Days over " + str(model.passedDays))
	model.doSalaryPayment()
	
func getDayProgress() -> float:
	return 1 - ($DayTimer.time_left / $DayTimer.wait_time)

func onOpenInventory():
	$Desk/JobApplication.onClose()
	$Desk/MascotDetails.onClose()
	$Desk/Inventory.onOpen()

func onOpenJobApplication():
	$Desk/Inventory.onClose()
	$Desk/MascotDetails.onClose()
	$Desk/JobApplication.onOpen()

func onOpenMascotDetails(mascot:Mascot):
	$Desk/Inventory.onClose()
	$Desk/JobApplication.onClose()
	$Desk/MascotDetails.onOpen(mascot)
