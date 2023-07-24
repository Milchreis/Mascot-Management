extends MarginContainer

func showMessage(message:String, durationInSecs=3.0):
	self.visible = true
	find_node("message").text = message.to_upper()
	SlideUtil.slideControl(self, self, Vector2(0, 160), Vector2(0, 150), 0.5)
	
	get_tree().create_timer(durationInSecs).connect("timeout", self, "_hideMessage")
	
func _hideMessage():
	SlideUtil.slideControl(self, self, Vector2(0, 150), Vector2(0, 160), 0.5)
