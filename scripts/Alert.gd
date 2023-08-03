extends MarginContainer

export var color:Color = "#cf5d8b"

func showError(message:String, durationInSecs=6.0, color:Color="#cf5d8b"):
	_show(message, durationInSecs, color)

func showMessage(message:String, durationInSecs=6.0, color:Color="#66aa5d"):
	_show(message, durationInSecs, color)

func _show(message:String, durationInSecs, color:Color):
	self.visible = true
	$bg.color = color
	find_node("message").text = message.to_upper()
	SlideUtil.slideControl(self, self, Vector2(0, 160), Vector2(0, 150), 0.5)
	get_tree().create_timer(durationInSecs).connect("timeout", self, "_hideMessage")

func _hideMessage():
	SlideUtil.slideControl(self, self, Vector2(0, 150), Vector2(0, 160), 0.5)
