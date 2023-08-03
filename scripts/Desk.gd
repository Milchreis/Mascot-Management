extends Control

var model:GameModel
var lastBalance := 500
var lastSatisfaction := 0.0

func _process(_delta):
	updateSatisfactionView()
	updateBalanceView()

func onDayPassed():
	var satisDiff = model.getClientSatisfaction() - lastSatisfaction
	if satisDiff != 0: 
		$Appbar/SatisfactionAnimationPlayer.play("SatisfactionUpdate")
	
	var balanceDiff = model.balance - lastBalance
	if balanceDiff != 0: 
		$Appbar/BalanceAnimationPlayer.play("BalanceUpdate")
		
		var label = $Appbar/Balance/ChangeAmount
		label.text = str(balanceDiff) + "$"
		label.rect_position = $Appbar/Balance/Amount.rect_position
		label.visible = true
		
		var tween := create_tween() \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT) \
			.set_parallel()
		
		var targetPosition
				
		if sign(balanceDiff) == -1:
			label.add_color_override("font_color", Color("cf5d8b"))
			targetPosition = Vector2(label.rect_position.x, 40)
			
		elif sign(balanceDiff) == 1:
			label.add_color_override("font_color", Color("b0d07e"))
			targetPosition = Vector2(label.rect_position.x, -20)
			$Appbar/Balance/PositiveBalancePlayer.play()
	
		tween.tween_property(label, "visible", false, 1.5)
		tween.tween_property(label, "rect_position", targetPosition, 1.5)	
	
	lastBalance = model.balance
	lastSatisfaction = model.getClientSatisfaction()

func updateSatisfactionView() -> void:
	$Appbar/ClientSatisfaction/Background/Progess.value = model.getClientSatisfaction()
	
	$Appbar/ClientSatisfaction/Background/days.visible = model.daysInFullSatisfaction > 0
	if model.daysInFullSatisfaction == 1:
		 $Appbar/ClientSatisfaction/Background/days.text = str(model.daysInFullSatisfaction) + " DAY"
	else: 
		$Appbar/ClientSatisfaction/Background/days.text = str(model.daysInFullSatisfaction) + " DAYS"

func updateBalanceView() -> void:
	$Appbar/Balance/Amount.text = str(model.balance) + "$"
