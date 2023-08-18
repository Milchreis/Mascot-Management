extends Node2D

export var target_volume:=-25.0

var slientDB = -100
var steps = 0


func _ready():
	Input.set_custom_mouse_cursor(load("res://gfx/hand.png"), Input.CURSOR_POINTING_HAND)
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
		node.volume_db = max(node.volume_db-2, target_volume)
	else:
		node.volume_db = min(node.volume_db+2, target_volume)

func dimmMusicTo(volume_db:float):
	target_volume = volume_db

func toggleMusic():
	if target_volume == slientDB: target_volume = -15.0
	else: target_volume = slientDB

func isSilent() -> bool:
	return $Music.volume_db == slientDB
