extends Node2D

func _ready():
	$AnimationPlayer.play("intro")

func onStart():
	$AnimationPlayer.connect("animation_finished", self, "switchScene")
	$AnimationPlayer.play("outro")
	
func switchScene(animationName):
	get_tree().change_scene("res://scenes/MainScene.tscn")
