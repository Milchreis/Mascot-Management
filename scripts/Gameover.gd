extends Node2D

signal try_again

func showScreen(model:GameModel):
	visible = true
	$Controls/DaysTotal.text = str(model.passedDays)
	$Controls/DaysBest.text = str(model.daysInFullSatisfactionBest)
	
	$Player.play()
	$Sprite/AnimationPlayer.play("sad")
	SlideUtil.slideInFromBottom(self, self, 0.5)

func _onTryAgainPressed():
	SlideUtil.jumpControl(self, $Controls/TryAgain).connect("finished", self, "_slideOut")

func _slideOut():
	$Sprite/AnimationPlayer.stop()
	SlideUtil.slideOutToBottom(self, self, 0.5).connect("finished", self, "_hide")
	emit_signal("try_again")

func _hide():
	visible = false
