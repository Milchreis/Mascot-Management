extends Node2D

var GameModel = load("res://scripts/GameModel.gd")

var model:GameModel = GameModel.new()

func _ready():
	add_child(model)
	model.connect("day_passed", $Desk, "onDayPassed")
	
	$Desk.model = model
	$Areas/Stats.model = model
	$Areas/JobApplication.model = model
	$Areas/Inventory.model = model
	$Areas/MascotDetails.model = model
	
	$Areas/JobApplication.createPool(4)
	onOpenJobApplication()
	
func _process(_delta):
	$Desk/Appbar/ClientSatisfaction/Background/Progess.value = model.getClientSatisfaction()
	$Desk/Appbar/Day/Background/Progess.value = model.getDayProgress()

func onOpenStatistics():
	slideTo(240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Inventory.onClose()
	$Areas/Stats.onOpen()

func onOpenInventory():
	slideTo(-240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Stats.onClose()
	$Areas/Inventory.onOpen()

func onOpenJobApplication():
	slideTo(0)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Stats.onClose()
	$Areas/JobApplication.onOpen()

func onOpenMascotDetails(mascot:Mascot):
	slideTo(-480)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/JobApplication.onClose()
	$Areas/Stats.onClose()
	$Areas/MascotDetails.onOpen(mascot)

func onMascotFire():
	onOpenInventory()

func slideTo(x):
	var tween := create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.tween_property($Areas, "position", Vector2(x, 0), 0.4)
