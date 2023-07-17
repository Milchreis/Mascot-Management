extends Control
class_name Stats

var model:GameModel

var maxHappiness := 0.0

func onOpen():
	model.connect("day_passed", self, "updateUI")
	updateUI()

func updateUI():
	maxHappiness = max(model.getClientSatisfaction(), maxHappiness)
	
	$LeftSideBackground/VBoxContainer/DaysValue.text = str(model.passedDays)
	$LeftSideBackground/VBoxContainer/MaxSatisValue.text = str(floor(maxHappiness*100.0)) + "%"

func onClose():
	model.disconnect("day_passed", self, "updateUI")
