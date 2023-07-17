extends Control

signal select(mascot)

export(bool) var showStats = true
export(bool) var showName = true
export(bool) var showHover = true
export(int) var salaryPerDay = 10

var mascot:Mascot

var COOLDOWN_MAX := 20
var selectCoolDown := COOLDOWN_MAX
var dotEmpty = load("res://gfx/dot_empty.png")
var dotFilled = load("res://gfx/dot_filled.png")

func _ready():
	$pic/Sprite.texture = load(mascot.spriteImage)
	$salary.text = str(mascot.salaryPerDay) + "$/d"
	$name.text = mascot.nickname.to_upper()
		
	if showStats: 
		$hoverBg.rect_size.y = 105
	else: 
		$hoverBg.rect_size.y = 76
		rect_min_size.y = 76
	
	createStats($StatsPanel/improPosition, mascot.improvisation)
	createStats($StatsPanel/reliabPosition, mascot.reliable)
	createStats($StatsPanel/charismaPosition, mascot.charisma)

func _process(_delta):
	$StatsPanel.visible = showStats
	$name.visible = showName
	$Busy.visible = mascot.in_training or mascot.isInEvent()
	$DaysRemaining.visible = mascot.in_training or mascot.isInEvent()
	$DaysRemaining.text = str(mascot.getRemainingDays())
	$pic/Sprite.flip_h = get_global_mouse_position().x > $pic/Sprite.global_position.x - $pic/Sprite.texture.get_width()/2
	# todo
	$Ill.visible = false
	
	if showHover: 
		$hoverBg.visible = isMouseOver(get_global_mouse_position())
	
	if showStats:
		setStats($StatsPanel/improPosition, mascot.improvisation)
		setStats($StatsPanel/reliabPosition, mascot.reliable)
		setStats($StatsPanel/charismaPosition, mascot.charisma)
		
	selectCoolDown = min(selectCoolDown + 1, COOLDOWN_MAX)

func _input(event):
	
	if event is InputEventMouseButton and isMouseOver(event.position):
		$pic/AnimationPlayer.play("hover")
		
		if event.button_index == BUTTON_LEFT and selectCoolDown == COOLDOWN_MAX:
			selectCoolDown = 0
			emit_signal("select", mascot)
	
	else: $pic/AnimationPlayer.stop()

func isMouseOver(_position):
	# it's a little hacky, but the InputEventMouseButton doesn't work with scroll together
	# and the Polroid-scene as Button doesn't fire the signal on click.
	var scrollAreaBeginY = 40	
	return (get_global_rect().has_point(_position) 
		and _position.y > scrollAreaBeginY)
		

func createStats(positionNode, propertyValue):
	for n in range(0, 5):
		var stat = Sprite.new()
		if n < int(propertyValue):stat.texture = dotFilled
		else: stat.texture = dotEmpty
		stat.position = positionNode.position
		stat.position.x += n * (stat.texture.get_width()+1)		
		positionNode.add_child(stat)
		
func setStats(positionNode, propertyValue):
	for n in range(0, 5):
		var stat:Sprite = positionNode.get_children()[n]
		if n < int(propertyValue):stat.texture = dotFilled
		else: stat.texture = dotEmpty
