extends Node2D

var GameModel = load("res://scripts/GameModel.gd")

var dayTimer := Timer.new()
var model:GameModel = GameModel.new(dayTimer)
var savegame:SaveGame = SaveGame.new()

var activeButton:Node
var activ_theme = load("res://gfx/header_buttons_active_theme.tres") 
var inactiv_theme = load("res://gfx/header_buttons_theme.tres") 

func _ready():
	$"/root/Music".dimmMusicTo(-25)
	
	dayTimer.start()
	dayTimer.connect("timeout", self, "onDayPassed")
	dayTimer.autostart = true
	dayTimer.wait_time = model.dayDurationInSeconds
	add_child(dayTimer)

	$Gameover.connect("try_again", self, "onTryAgain")

	model.connect("employee_gone", self, "onEmployeeIsGone")
	model.connect("employee_sabat", self, "onEmployeeIsInSabat")
	
	$Desk.model = model
	$Areas/Benefits.model = model
	$Areas/JobApplication.model = model
	$Areas/Inventory.model = model
	$Areas/MascotDetails.model = model
	
	onOpenJobApplication()
	SlideUtil.slideControl(self, $Desk, Vector2(240,0), Vector2.ZERO, 0.5)
	
	$IntroPlayer.connect("finished", self, "introFinished")
	$IntroPlayer.play()

func introFinished():
	$"/root/Music".dimmMusicTo(-10.0)
	
func onTryAgain():
	SlideUtil.slideOutToBottom(self, $Gameover, 0.5)
	model._reset()
	$Areas/JobApplication.reset()
	
	onOpenJobApplication()

func onDayPassed():
	$DayoverPlayer.play()
	model.onDayIsOver()
	$Desk.onDayPassed()
	$Areas/JobApplication.updateUI()
	$Areas/MascotDetails.reloadEvents()
	$Areas/MascotDetails.updateUI()
	
	if model.balance < 0:
		dayTimer.stop()
		$Gameover.visible = true
		SlideUtil.slideInFromBottom(self, $Gameover, 0.5)

func _process(_delta):
	$Desk/Appbar/ClientSatisfaction/Background/Progess.value = model.getClientSatisfaction()
	$Desk/Appbar/Day/Background/Progess.value = model.getDayProgress()
	
	$Desk/BenefitsBtn.theme = inactiv_theme
	$Desk/ApplicantsBtn.theme = inactiv_theme
	$Desk/EmployeesBtn.theme = inactiv_theme
	
	if activeButton: activeButton.theme = activ_theme

func onEmployeeIsGone(mascot:Mascot):
	$Alert.showMessage(mascot.nickname + " has left the company.")
	$Areas/Inventory.updateUI()
	$Areas/MascotDetails.updateUI()
	
func onEmployeeIsInSabat(mascot:Mascot):
	$Alert.showMessage(mascot.nickname + " is without salary in sabat for " + str(mascot.currentEvent.duration) + " days.")
	$Areas/MascotDetails.updateUI()

func onOpenStatistics():
	activeButton = $Desk/BenefitsBtn
	SlideUtil.jumpControl(self, activeButton)
	SlideUtil.slideToX(self, $Areas, 240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Inventory.onClose()
	$Areas/Benefits.onOpen()

func onOpenInventory():
	activeButton = $Desk/EmployeesBtn
	SlideUtil.jumpControl(self, activeButton)
	SlideUtil.slideToX(self, $Areas, -240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Benefits.onClose()
	$Areas/Inventory.onOpen()

func onOpenJobApplication():
	activeButton = $Desk/ApplicantsBtn
	SlideUtil.jumpControl(self, activeButton)
	SlideUtil.slideToX(self, $Areas, 0)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Benefits.onClose()
	$Areas/JobApplication.onOpen()

func onOpenMascotDetails(mascot:Mascot):
	activeButton = null
	SlideUtil.slideToX(self, $Areas, -480)
	$Desk/ClickPlayer.play()
	$Areas/Inventory.onClose()
	$Areas/JobApplication.onClose()
	$Areas/Benefits.onClose()
	$Areas/MascotDetails.onOpen(mascot)

func onMascotFire():
	onOpenInventory()
