extends Control

signal select(mascot)

var showStats = true
var showName = true
var showHover = true
var salaryPerDay = 10
var clickable = true

var mascot:Mascot
var sprites:Texture = load("res://gfx/mascots.png")

func _ready():
	$pic/Sprite.frame = mascot.spriteIndex
	$salary.text = "-" + str(mascot.salaryPerDay) + "$/d"
	$name.text = mascot.nickname.to_upper()
		
	if showStats: 
		$hoverBg.rect_size.y = 105
	else: 
		$hoverBg.rect_size.y = 76
		rect_min_size.y = 76
	
	$StatsPanel/Impro.value = mascot.improvisation
	$StatsPanel/Charisma.value = mascot.charisma
	$StatsPanel/Reliable.value = mascot.reliable

func _process(_delta):
	$StatsPanel.visible = showStats
	$name.visible = showName
	$Busy.visible = mascot.in_training or mascot.isInEvent()
	$Ill.visible = mascot.is_ill
	
	$DaysRemaining.visible = mascot.isOuccupied()
	$DaysRemaining.text = str(mascot.getRemainingDays())
	
	$waitlist.visible = !mascot.eventWaitlist.empty()
	$waitlist.text = ".".repeat(mascot.eventWaitlist.size())

	$pic/Sprite.flip_h = get_global_mouse_position().x > $pic/Sprite.global_position.x + 20
		
	if showHover: 
		$hoverBg.visible = isMouseOver(get_global_mouse_position())
	
	if showStats:
		$StatsPanel/Impro.value = mascot.improvisation
		$StatsPanel/Charisma.value = mascot.charisma
		$StatsPanel/Reliable.value = mascot.reliable
	
	if isMouseOver(get_global_mouse_position()):
		$pic/AnimationPlayer.get_animation("hover").loop = true
		$pic/AnimationPlayer.play("hover")
	else: 
		$pic/AnimationPlayer.get_animation("hover").loop = false
		$pic/AnimationPlayer.queue("still")

func _input(event):
	if event is InputEventMouseButton and isMouseOver(event.position):	
		if event.button_index == BUTTON_LEFT and clickable and event.is_pressed():
			print(mascot.nickname)
			clickable = false
			SlideUtil.jumpControl(self, self)
			emit_signal("select", mascot)

func isMouseOver(_position):
	# it's a little hacky, but the InputEventMouseButton doesn't work with scroll together
	# and the Polroid-scene as Button doesn't fire the signal on click.
	var scrollAreaBeginY = 40
	return (get_global_rect().has_point(_position) 
		and _position.y > scrollAreaBeginY)
