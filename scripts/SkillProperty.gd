class_name SkillProperty
extends Control

export var shortLabel:String
export var longLabel:String
export var value:float

var dotEmpty = load("res://gfx/dot_empty.png")
var dotFilled = load("res://gfx/dot_filled.png")
var dotHalfFilled = load("res://gfx/dot_half-filled.png")

func _ready():
	$label.text = shortLabel
	createStats($position, value)

func _process(_delta):
	setStats($position, value)

func playTrainingDoneAnimation():
	$Particles.emitting = true
	
	for n in range(0, 5):
		if value > float(n) + 0.49 or int(value) > n:
			var stat:Sprite = $position.get_children()[n]
			SlideUtil.jump(self, stat, 5, 0.25, n*0.1)

func createStats(positionNode:Node2D, propertyValue:float):
	for n in range(0, 5):
		var stat = Sprite.new()
		stat.texture = dotEmpty
		
		if propertyValue > float(n) + 0.49: stat.texture = dotHalfFilled
		if int(propertyValue) > n: stat.texture = dotFilled
		
		stat.position = positionNode.position
		stat.position.x += n * (stat.texture.get_width()+1)
		positionNode.add_child(stat)
		
func setStats(positionNode, propertyValue):
	for n in range(0, 5):
		var stat:Sprite = positionNode.get_children()[n]
		stat.texture = dotEmpty
		
		if propertyValue > float(n) + 0.49: stat.texture = dotHalfFilled
		if int(propertyValue) > n: stat.texture = dotFilled

func onEntered():
	$position.visible = false
	$label.text = longLabel

func onExited():
	$position.visible = true
	$label.text = shortLabel
