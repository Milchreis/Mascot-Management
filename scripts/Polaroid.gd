extends Control

signal select(mascot)

export(bool) var showStats = true
export(bool) var showName = true
export(bool) var showHover = true
export(int) var salaryPerDay = 10

var mascot:Mascot

var dotEmpty = load("res://gfx/dot_empty.png")
var dotFilled = load("res://gfx/dot_filled.png")

func _ready():
	$pic/Sprite.texture = load(mascot.spriteImage)
	$salary.text = str(mascot.salaryPerDay) + "$/d"
	$name.text = mascot.nickname.to_upper()
	$pic.color = mascot.bgColor
	
	createStats($StatsPanel/improPosition, mascot.improvisation)
	createStats($StatsPanel/reliabPosition, mascot.reliable)
	createStats($StatsPanel/charismaPosition, mascot.charisma)

func _process(_delta):
	$StatsPanel.visible = showStats
	$name.visible = showName
	$Busy.visible = mascot.in_training or mascot.isInEvent()
	$DaysRemaining.visible = mascot.in_training or mascot.isInEvent()
	$DaysRemaining.text = str(mascot.getRemainingDays())
	# todo
	$Ill.visible = false
	
	if showHover: $hoverBg.visible = get_global_rect().has_point(get_global_mouse_position())
	
	if showStats:
		setStats($StatsPanel/improPosition, mascot.improvisation)
		setStats($StatsPanel/reliabPosition, mascot.reliable)
		setStats($StatsPanel/charismaPosition, mascot.charisma)

## temporary mouse input for hiring mascots
func _input(event):
	if event is InputEventMouseButton and get_global_rect().has_point(event.position):
		if event.button_index == BUTTON_LEFT:
			emit_signal("select", mascot)

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
