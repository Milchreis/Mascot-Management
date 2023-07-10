extends Node
class_name Mascot

var RandomNames = load("res://scripts/random_names.gd").new()
var sprites = [
	"res://gfx/mascots/ape1.png",
	"res://gfx/mascots/dog1.png",
	"res://gfx/mascots/chick1.png"	
]

var bg_colors = ["#7be1f6", "#ffe3ae", "#cdbbab", "#b0d07e", "#ffbae1"]

export var nickname:String = RandomNames.get_first_name()

export var crazy:float = rand_range(0.0, 5.0)
export var reliable:float = rand_range(0.0, 5.0)
export var xp:float = rand_range(0.0, 5.0)

export var salaryPerDay:int = rand_range(10, 50)
export var spriteImage:String = sprites[randi() % sprites.size()]
export var bgColor:String = bg_colors[randi() % bg_colors.size()]

var client_satisfaction:float = 0.30
var jobs:int = 0

var in_training := false
var in_training_days := 0
var training_price := 50
var training_duration := 1

# TODO: 
#  - salary depending on properties

func startTraining() -> void:
	print("Training started for ", nickname)
	in_training = true

func updateTraining() -> void:
	if in_training == false: return
	in_training_days+=1
	
	if in_training_days > training_duration:
		print("Training ended for ", nickname)
		in_training = false
		in_training_days = 0
		
		reliable = min(reliable + rand_range(0.0, 1.0), 5)
		crazy = min(crazy + rand_range(0.0, 1.0), 5)
		xp += 1

func _to_string() -> String:
	return (
		"nickname="+nickname +
		", crazy="+str(crazy) +
		", raliable="+str(reliable) + 
		", xp="+str(xp)+
		", salaryPerDay="+str(salaryPerDay))
