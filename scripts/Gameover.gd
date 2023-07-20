extends Node2D

signal try_again

func _ready():
	$Sprite/AnimationPlayer.play("sad")

func _onTryAgainPressed():
	emit_signal("try_again")
