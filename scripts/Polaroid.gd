extends Control

export(bool) var showStats = true
export(int) var salaryPerDay = 10

var mascot:Mascot

var dotEmpty = load("res://gfx/dot_empty.png")
var dotFilled = load("res://gfx/dot_filled.png")

func _ready():
	$pic/Sprite.texture = load(mascot.spriteImage)
	$salary.text = str(mascot.salaryPerDay) + "$/d"
	setStats($StatsPanel/crazyPosition, mascot.crazy)
	setStats($StatsPanel/reliabPosition, mascot.reliable)
	setStats($StatsPanel/xpPosition, mascot.xp)
	print(mascot.to_string())

func _process(_delta):
	$StatsPanel.visible = showStats

func setStats(positionNode, propertyValue):
	for n in range(0, 5):
		var stat = Sprite.new()
		
		if n < int(propertyValue):stat.texture = dotFilled
		else: stat.texture = dotEmpty
		
		stat.position = positionNode.position
		stat.position.x += n * (stat.texture.get_width()+1)
		positionNode.add_child(stat)
