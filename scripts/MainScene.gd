extends Node2D

var GameModel = load("res://scripts/GameModel.gd")
var model:GameModel = GameModel.new()

func _ready():
	add_child(model)
	
	$Desk.model = model
	$Desk/Areas/JobApplication.model = model
	$Desk/Areas/Inventory.model = model
	$Desk/Areas/MascotDetails.model = model
	
	$Desk/Areas/JobApplication.createPool(3)
	onOpenJobApplication()

func _process(_delta):
	pass
	
func onOpenInventory():
	slideRight()
	$Desk/Areas/JobApplication.onClose()
	$Desk/Areas/MascotDetails.onClose()
	$Desk/Areas/Inventory.onOpen()

func onOpenJobApplication():
	slideLeft()
	$Desk/Areas/Inventory.onClose()
	$Desk/Areas/MascotDetails.onClose()
	$Desk/Areas/JobApplication.onOpen()

func onOpenMascotDetails(mascot:Mascot):
	slideRight()
	$Desk/Areas/Inventory.onClose()
	$Desk/Areas/JobApplication.onClose()
	$Desk/Areas/MascotDetails.onOpen(mascot)

func onBackToInventory():
	slideLeft()
	$Desk/Areas/JobApplication.onClose()
	$Desk/Areas/MascotDetails.onClose()
	$Desk/Areas/Inventory.onOpen()

func onMascotFire():
	onBackToInventory()

func slideLeft():
	var panels = $Desk/Areas
	var tween := create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(panels, "position", Vector2(panels.position.x + 240, 0), 0.3)

func slideRight():		
	var panels = $Desk/Areas
	var tween := create_tween() \
		.set_trans(Tween.TRANS_QUINT) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property(panels, "position", Vector2(panels.position.x - 240, 0), 0.3)

