extends Node
class_name Mascot

var RandomNames = load("res://scripts/random_names.gd").new()

export var nickname:String = RandomNames.get_first_name()

export var crazy:float = rand_range(0.0, 5.0)
export var reliable:float = rand_range(0.0, 5.0)
export var xp:float = rand_range(0.0, 5.0)

export var salaryPerDay:int = rand_range(10, 50)

# TODO: 
#  - salary depending on properties
