class_name Benefit
extends Button

signal clicked(type)
signal over(type)

export var price:int
export var tooltip:String
export var days:int
export var type:String
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
	
	disabled = model.balance <= price or is_active()

func onDayOver():
	if is_active():
		model.balance -= price
		working_day = max(working_day - 1, 0)
		if working_day == 0:
			emit_signal("over", type)

func onClicked():
	if audio: player.play()
	SlideUtil.jumpControl(self, self)
	working_day = days
	emit_signal("clicked", type)

func is_active() -> bool:
	return working_day > 0
