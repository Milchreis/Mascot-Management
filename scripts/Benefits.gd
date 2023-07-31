extends Control
class_name Benefits

var model:GameModel

func onOpen():
	model.connect("day_passed", self, "onDayOver")
	
	for node in $Buttons.get_children():
		node.model = model
		
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
	model.disconnect("day_passed", self, "onDayOver")

