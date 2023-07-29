extends Control
class_name Benefits

var model:GameModel

var hints = {
	"Celebration": "Start a party for your mascots. It will keep your mascots for more days.",
	"TeamBuilding": "Shape your team into a strong unit. It will increase the reliabilty and keeps your mascots in company.",
	"FreshFruits": "Offer your mascots fresh fruit to be fit and healthy. It will decrease the risk for illness by 50 percent.",
	"SportCourses": "Let your mascots do some free workouts. It will decrease the risk for illness by 80 percent.",
}

func onOpen():
	model.connect("day_passed", self, "updateUI")
		
func _process(_delta):
	updateUI()

func updateUI():
	$Celebration.disabled = model.balance <= 100
	$TeamBuilding.disabled = model.balance <= 200
	
	$FreshFruits.disabled = model.balance <= 10
	$SportCourses.disabled = model.balance <= 40
	
	var hint = $InfoPanel/HBoxContainer/VBoxContainer/hint
	$InfoPanel.visible = false
	
	for node in [$Celebration, $FreshFruits, $SportCourses, $TeamBuilding]:
		if node.get_global_rect().has_point(get_global_mouse_position()):
			hint.text = hints[node.name]
			$InfoPanel.visible = true

func onClose():
	model.disconnect("day_passed", self, "updateUI")

func _onCelebration():
	model.balance -= 100
