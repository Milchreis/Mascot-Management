extends Control
class_name Benefits

var model:GameModel

func onOpen():
	if !model.is_connected("day_passed", self, "onDayOver"):
		model.connect("day_passed", self, "onDayOver")
	
	for node in $Buttons.get_children():
		node.connect("clicked", self, "onBenefitClicked")
		node.connect("over", self, "onBenefitIsOver")
		node.model = model

func reset():
	for node in $Buttons.get_children():
		node.working_day = 0

func _process(_delta):
	updateUI()
	
func onDayOver():
	for node in $Buttons.get_children(): node.onDayOver()
	updateUI()
	
func updateUI():
	var hint = $InfoPanel/HBoxContainer/VBoxContainer/hint
	$InfoPanel.visible = false
	
	for node in $Buttons.get_children():
		if node.get_global_rect().has_point(get_global_mouse_position()):
			hint.text = node.tooltip
			$InfoPanel.visible = true

func onClose():
	for node in $Buttons.get_children():
		node.disconnect("clicked", self, "onBenefitClicked")
		node.disconnect("over", self, "onBenefitIsOver")

func onBenefitIsOver(type:String):
	for e in model.employees:
		var employee:Mascot = e
			
		if type == $Buttons/FreshFruits.type:
			employee.illness_decrease_factor = max(0.0, employee.illness_decrease_factor - 0.2)

		if type == $Buttons/SportCourses.type:
			employee.illness_decrease_factor = max(0.0, employee.illness_decrease_factor - 0.8)

func onBenefitClicked(type:String):
	for e in model.employees:
		var employee:Mascot = e
		
		if type == $Buttons/Celebration.type:
			employee.leaveCooldownInDays = max(5, employee.leaveCooldownInDays)

		if type == $Buttons/TeamBuilding.type:
			employee.leaveCooldownInDays = max(10, employee.leaveCooldownInDays)
			employee.leaveProbability = max(0, employee.leaveProbability - 0.02)
			
		if type == $Buttons/FreshFruits.type:
			employee.illness_decrease_factor = min(employee.illness_decrease_factor + 0.2, 1)

		if type == $Buttons/SportCourses.type:
			employee.illness_decrease_factor = min(employee.illness_decrease_factor + 0.8, 1)
