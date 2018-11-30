extends Node

func _on_buttonPlay_pressed():
	transitionScene.fadeTo("res://scenes/mainGame.tscn") #por esse motivo deixamos singleton na transition
