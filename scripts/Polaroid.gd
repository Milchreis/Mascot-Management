extends Control

signal select(mascot)

var showStats = true
var showInfo = false
var showName = true
var showHover = true
var salaryPerDay = 10
var clickable = true

var isOver = false
var mascot:Mascot
var sprites:Texture = load("res://gfx/mascots.png")

func _ready():
	$pic/Sprite.frame = mascot.spriteIndex
	$salary.text = str(mascot.getBalance()) + "$/d"
	$name.text = mascot.nickname.to_upper()
	$hoverBg.visible = false
		
	if showStats or showInfo: 
		$hoverBg.rect_size.y = 105
	else: 
		$hoverBg.rect_size.y = 76
		rect_min_size.y = 76
	
	$StatsPanel/Impro.value = mascot.improvisation
	$StatsPanel/Charisma.value = mascot.charisma
	$StatsPanel/Reliable.value = mascot.reliable

func onTrainingDone():
	$StatsPanel/Impro.playTrainingDoneAnimation()
	$StatsPanel/Charisma.playTrainingDoneAnimation()
	$StatsPanel/Reliable.playTrainingDoneAnimation()

func playBalanceChanged(value):
		var label = $salaryChanged
		label.text = str(value) + "$   "
		label.visible = true
		label.rect_position = Vector2(12, 60)
		
		var tween := create_tween() \
			.set_trans(Tween.TRANS_CUBIC) \
			.set_ease(Tween.EASE_OUT) \
			.set_parallel()
		
		var targetPosition
				
		if sign(value) == -1:
			label.add_color_override("font_color", Color("cf5d8b"))
			targetPosition = Vector2(label.rect_position.x, label.rect_position.y + 20)
			
		elif sign(value) == 1:
			label.add_color_override("font_color", Color("b0d07e"))
			targetPosition = Vector2(label.rect_position.x, label.rect_position.y - 30)
	
		tween.tween_property(label, "visible", false, 1)
		tween.tween_property(label, "rect_position", targetPosition, 1)

func _process(_delta):
	if clickable and isOver: mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	else: mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	$Info.visible = showInfo
	$StatsPanel.visible = showStats
	$name.visible = showName
	$Busy.visible = mascot.in_training or mascot.isInEvent()
	$Ill.visible = mascot.is_ill
	$salary.text = str(mascot.getBalance()) + "$/d"
	
	if mascot.getBalance() >= 0:
		$salary.set("custom_colors/font_color", Color("66aa5d"))
	else:
		$salary.set("custom_colors/font_color", Color("cf5d8b"))
	
	$DaysRemaining.visible = mascot.isOuccupied()
	$DaysRemaining.text = str(mascot.getRemainingDays())
	
	if mascot.is_ill:
		$DaysRemaining.set("custom_colors/font_color", Color("cf5d8b"))
	else:
		$DaysRemaining.set("custom_colors/font_color", Color("66aa5d"))
	
	$waitlist.visible = !mascot.eventWaitlist.empty()
	$waitlist.text = ".".repeat(mascot.eventWaitlist.size())

	$pic/Sprite.flip_h = get_global_mouse_position().x > $pic/Sprite.global_position.x + 20
	
	if showStats:
		$StatsPanel/Impro.value = mascot.improvisation
		$StatsPanel/Charisma.value = mascot.charisma
		$StatsPanel/Reliable.value = mascot.reliable
	
	if showInfo:
		if mascot.is_ill:
			$Info/state.text = "is sick"
			$Info/state.set("custom_colors/font_color", Color("cf5d8b"))
		elif mascot.in_training:
			$Info/state.text = "in training"
			$Info/state.set("custom_colors/font_color", Color("66aa5d"))
			
		elif mascot.isInEvent():
			if mascot.currentEvent.isSabbat():
				$Info/state.text = "in sabbat"
			else:
				$Info/state.text = "at work"
			if isOver: $Info/state.set("custom_colors/font_color", Color("635d96"))
			else: $Info/state.set("custom_colors/font_color", Color("66aa5d"))
		else:
			$Info/state.text = "is bored"
			$Info/state.set("custom_colors/font_color", Color("635d96"))
		
		$Info/jobs.text = str("done jobs: ", mascot.jobs)
		$Info/employed.text = str("EMPLOYED: ", mascot.daysEmployeed, " d")
		$Info/ClientSatisfaction.value = mascot.client_satisfaction
	
	if isOver:
		$pic/AnimationPlayer.get_animation("hover").loop = true
		$pic/AnimationPlayer.play("hover")
	else: 
		$pic/AnimationPlayer.get_animation("hover").loop = false
		$pic/AnimationPlayer.queue("still")

func _input(event):
	if event is InputEventMouseButton and isOver:
		if event.button_index == BUTTON_LEFT and clickable and event.is_pressed():
			clickable = false
			SlideUtil.jumpControl(self, self)
			emit_signal("select", mascot)

func onEntered():
	$hoverBg.visible = true
	isOver = true

func onExited():
	$hoverBg.visible = false
	isOver = false
