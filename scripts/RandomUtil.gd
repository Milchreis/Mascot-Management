class_name RandomUtil
extends Node

static func withChanceOf(fraction:float) -> bool: 
	 return rand_range(0.0, 1.0) <= fraction

static func getRandom(array):
	return array[randi() % array.size()]
