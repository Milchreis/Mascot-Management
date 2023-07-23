extends Node2D

var GameModel = load("res://scripts/GameModel.gd")

var model:GameModel = GameModel.new()
var savegame:SaveGame = SaveGame.new()

func _ready():
	
	var save = SaveGame.load_savegame()
	if save: 
		savegame = save
		model.loadSavegame(savegame)
	
	add_child(model)
	model.connect("day_passed", $Desk, "onDayPassed")
	model.connect("day_passed", self, "onDayPassed")
	
	$Gameover.connect("try_again", self, "onTryAgain")
	
	$Desk.model = model
	$Areas/Stats.model = model
	$Areas/JobApplication.model = model
	$Areas/Inventory.model = model
	$Areas/MascotDetails.model = model
	
	model.increaseApplicantsPool(3)
	onOpenJobApplication()
	SlideUtil.slideControl(self, $Desk, Vector2(240,0), Vector2.ZERO, 0.5)

func onTryAgain():	
	SlideUtil.slideOutToBottom(self, $Gameover, 0.5)
	model._reset()
	$Areas/JobApplication.reset()
	$Areas/JobApplication.createPool(3)
	
	onOpenJobApplication()

func onDayPassed():
	savegame.write_savegame(model)
	
	$DayoverPlayer.play()
	
	if RandomUtil.withChanceOf(0.1) and $Areas/JobApplication.applicants.size() < 20:
		$Areas/JobApplication.createPool(2)
		
	if RandomUtil.withChanceOf(0.5) and model.openEvents.size() < 3:
		model.createRandomEvents(3)
		
	if model.balance < 0:
		model.dayTimer.stop()
		$Gameover.visible = true
		SlideUtil.slideInFromBottom(self, $Gameover, 0.5)

func _process(_delta):
	$Desk/Appbar/ClientSatisfaction/Background/Progess.value = model.getClientSatisfaction()
	$Desk/Appbar/Day/Background/Progess.value = model.getDayProgress()

func onOpenStatistics():
	SlideUtil.slideToX(self, $Areas, 240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Inventory.onClose()
	$Areas/Stats.onOpen()

func onOpenInventory():
	SlideUtil.slideToX(self, $Areas, -240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Stats.onClose()
	$Areas/Inventory.onOpen()

func onOpenJobApplication():
	SlideUtil.slideToX(self, $Areas, 0)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Stats.onClose()
	$Areas/JobApplication.onOpen()

func onOpenMascotDetails(mascot:Mascot):
	SlideUtil.slideToX(self, $Areas, -480)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/JobApplication.onClose()
	$Areas/Stats.onClose()
	$Areas/MascotDetails.onOpen(mascot)

func onMascotFire():
	onOpenInventory()
