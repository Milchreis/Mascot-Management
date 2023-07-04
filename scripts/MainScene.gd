extends Node2D

var Mascot = load("res://scripts/Mascot.gd")
var Polaroid = preload("res://scenes/Polaroid.tscn")

var balance:int = 100
var client_statisfaction:float = 0
var passedDays:int = 0

func _ready():
		
	$DayTimer.connect("timeout", self, "onDayIsOver")
	$DayTimer.start()
	
	updateBalanceView()
	updateSatisfactionView()

func _process(delta):
	if client_statisfaction < 100.0: 
		client_statisfaction += 0.1
		balance+=1
	
	updateSatisfactionView()
	updateBalanceView()

func onDayIsOver() -> void:
	passedDays+=1
	print("Days over " + str(passedDays))

	var mascot1 = createMascot()
	print(mascot1._to_string())
	var polaroid = Polaroid.instance()
	polaroid.mascot = mascot1
	$Desk/JobApplication/PolaroidSelector.add_child(polaroid)

func createMascot() -> Mascot:
	randomize()
	return Mascot.new()

func updateSatisfactionView() -> void:
	$Desk/Appbar/ClientSatisfaction/Background/Progess.value = int(client_statisfaction)

func updateBalanceView() -> void:
	$Desk/Appbar/Balance/Amount.text = str(balance) + "$"
