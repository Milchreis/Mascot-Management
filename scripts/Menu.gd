extends Node2D

export var target_volume:=-10.0

func _ready():
	$AnimationPlayer.play("intro")

func onStart():
	dimmMusicTo(-40.0)
	$AnimationPlayer.connect("animation_finished", self, "switchScene")
	$AnimationPlayer.play("outro")
	
func switchScene(animationName):
	get_tree().change_scene("res://scenes/MainScene.tscn")

func _process(_delta):
	var node = $Music
	if node.volume_db > target_volume:
		node.volume_db = max($Music.volume_db-2, target_volume)
	else:
		node.volume_db = min($Music.volume_db+2, target_volume)

func dimmMusicTo(volume_db:float):
	target_volume = volume_db

func toggleMusic():
	if target_volume == -100: target_volume = -10.0
	else: target_volume = -100
