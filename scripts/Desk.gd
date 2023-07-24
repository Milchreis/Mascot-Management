extends Control

var model:GameModel
var lastBalance := 500

func _process(_delta):
	updateSatisfactionView()
	updateBalanceView()

func onDayPassed():
	var diff = model.balance - lastBalance
	if diff == 0: return
	
	var label = $Appbar/Balance/ChangeAmount
	label.text = str(diff) + "$"
	label.rect_position = $Appbar/Balance/Amount.rect_position
	label.visible = true
	
	var tween := create_tween() \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT) \
		.set_parallel()
	
	var targetPosition
			
	if sign(diff) == -1:
		label.add_color_override("font_color", Color("cf5d8b"))
		targetPosition = Vector2(label.rect_position.x, 40)
	elif sign(diff) == 1:
		label.add_color_override("font_color", Color("b0d07e"))
		targetPosition = Vector2(label.rect_position.x, -20)
		$Appbar/Balance/PositiveBalancePlayer.play()
	
	tween.tween_property(label, "visible", false, 1.5)
	tween.tween_property(label, "rect_position", targetPosition, 1.5)	
	
	lastBalance = model.balance

func updateSatisfactionView() -> void:
	$Appbar/ClientSatisfaction/Background/Progess.value = model.getClientSatisfaction()

func updateBalanceView() -> void:
	$Appbar/Balance/Amount.text = str(model.balance) + "$"
