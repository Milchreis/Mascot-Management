extends ColorRect

var model:GameModel

func _ready():
	pass # Replace with function body.

func _process(_delta):	
	updateSatisfactionView()
	updateBalanceView()

func updateSatisfactionView() -> void:
	$Appbar/ClientSatisfaction/Background/Progess.value = int(model.client_statisfaction)

func updateBalanceView() -> void:
	$Appbar/Balance/Amount.text = str(model.balance) + "$"
