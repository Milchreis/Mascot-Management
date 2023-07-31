class_name Benefit
extends Button

export var price:int
export var tooltip:String
export var days:int
export var audio:AudioStream

var model:GameModel
var player:AudioStreamPlayer
var working_day := 0

func _ready():
	player = AudioStreamPlayer.new()
	player.stream = audio
	add_child(player)

func _process(_delta):
	updateUI()
	
func updateUI():
	if !model: return
	
	disabled = model.balance <= price

func onDayOver():
	if working_day > 0:
		model.balance -= price
		working_day = max(working_day - 1, 0)

func onClicked():
	if audio: player.play()
	SlideUtil.jumpControl(self, self)
	working_day = days
