extends Node
class_name Mascot

var RandomNames = load("res://scripts/random_names.gd").new()

export var nickname:String = RandomNames.get_first_name()

export var crazy:float = rand_range(0.0, 5.0)
export var reliable:float = rand_range(0.0, 5.0)
export var xp:float = rand_range(0.0, 5.0)

export var salaryPerDay:int = rand_range(10, 50)
export var spriteImage:String = "res://gfx/mascots/ape1.png"

var client_satisfaction:float = 0
var jobs:int = 0

# TODO: 
#  - salary depending on properties

func _to_string():
	return (
		"nickname="+nickname +
		", crazy="+str(crazy) +
		", raliable="+str(reliable) + 
		", xp="+str(xp)+
		", salaryPerDay="+str(salaryPerDay))
