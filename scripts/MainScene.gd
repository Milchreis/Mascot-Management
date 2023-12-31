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
	
	Input.set_custom_mouse_cursor(load("res://gfx/hand.png"), Input.CURSOR_POINTING_HAND)
	
	dayTimer.connect("timeout", self, "onDayPassed")
	dayTimer.wait_time = model.dayDurationInSeconds
	add_child(dayTimer)

	$Gameover.connect("try_again", self, "onTryAgain")

	model.connect("employee_gone", self, "onEmployeeIsGone")
	model.connect("employee_sabbat", self, "onEmployeeIsInSabbat")
	
	$Desk.model = model
	$Areas/Benefits.model = model
	$Areas/JobApplication.model = model
	$Areas/Inventory.model = model
	$Areas/MascotDetails.model = model
	
	$Areas/JobApplication.connect("hired", self, "onMascotHired")
	$Areas/MascotDetails.connect("accept", self, "onAcceptEvent")
	$Areas/MascotDetails.connect("close", self, "onOpenInventory")
	$Areas/Inventory.connect("select", self, "onOpenMascotDetails")
	
	onOpenJobApplication()
	SlideUtil.slideControl(self, $Desk, Vector2(240,0), Vector2.ZERO, 0.5)
	
	$IntroPlayer.connect("finished", self, "introFinished")
	$IntroPlayer.play()

func introFinished():
	if !$"/root/Music".isSilent():
		$"/root/Music".dimmMusicTo(-15.0)
	
func onTryAgain():
	model._reset()
	dayTimer.stop()
	$Areas/JobApplication.reset()
	$Areas/Benefits.reset()
	
	onOpenJobApplication()

func onDayPassed():
	$DayoverPlayer.play()
	$WonParticles.emitting = false
	model.onDayIsOver()
	$Desk.onDayPassed()
	$Areas/JobApplication.updateUI()
	$Areas/MascotDetails.reloadEvents()
	$Areas/MascotDetails.updateUI()

	if model.balance < 0:
		dayTimer.stop()
		$Gameover.showScreen(model)

	if model.daysInFullSatisfaction == 1:
		$Alert.showMessage("All clients love you. Keep your business as long as possible")
	
	if model.daysInFullSatisfaction == 11:
		onWon()
		
func _process(_delta):	
	$Desk/BenefitsBtn.theme = inactiv_theme
	$Desk/ApplicantsBtn.theme = inactiv_theme
	$Desk/EmployeesBtn.theme = inactiv_theme
	
	if activeButton: activeButton.theme = activ_theme

func onEmployeeIsGone(mascot:Mascot):
	$Alert.showError(mascot.nickname + " has left the company.")
	$Areas/Inventory.updateUI()
	$Areas/MascotDetails.updateUI()
	
func onEmployeeIsInSabbat(mascot:Mascot):
	$Alert.showError(mascot.nickname + " is without salary in sabbat for " + str(mascot.currentEvent.duration) + " days.")
	$Areas/MascotDetails.updateUI()

func onWon():
	$WonParticles.emitting = true
	$ApplausePlayer.play()
	$Alert.showMessage("Your company is loved for 10 days. You won the game!", 10)


func onOpenStatistics():
	if activeButton == $Desk/BenefitsBtn: return
	
	activeButton = $Desk/BenefitsBtn
	SlideUtil.jumpControl(self, activeButton)
	SlideUtil.slideToX(self, $Areas, 240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Inventory.onClose()
	$Areas/Benefits.onOpen()

func onOpenInventory():
	if activeButton == $Desk/EmployeesBtn: return
	
	activeButton = $Desk/EmployeesBtn
	SlideUtil.jumpControl(self, activeButton)
	SlideUtil.slideToX(self, $Areas, -240)
	$Desk/ClickPlayer.play()
	$Areas/JobApplication.onClose()
	$Areas/MascotDetails.onClose()
	$Areas/Benefits.onClose()
	$Areas/Inventory.onOpen()

func onOpenJobApplication():
	if activeButton == $Desk/ApplicantsBtn: return
	
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

func onAcceptEvent(event:Event, mascot:Mascot):
	if dayTimer.is_stopped(): dayTimer.start()

func onMascotHired(mascot:Mascot):
	onOpenMascotDetails(mascot)
	
func onMascotFire():
	onOpenInventory()

func onToggleMusic():
	$"/root/Music".toggleMusic()
	$IntroPlayer.volume_db = -100
