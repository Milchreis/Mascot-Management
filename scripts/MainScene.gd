extends Node2D

var GameModel = load("res://scripts/GameModel.gd")
var model:GameModel = GameModel.new()

func _ready():
	add_child(model)
	
	$Desk.model = model
	$Desk/JobApplication.model = model
	$Desk/Inventory.model = model
	$Desk/MascotDetails.model = model
	
	$Desk/JobApplication.createPool(3)
	onOpenJobApplication()

func _process(_delta):
	pass
	
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

func onMascotFire():
	onOpenInventory()
