extends Node2D

func destroy():
	get_node("Sprite").queue_free()
	get_node("shape").queue_free()
	get_node("particles").set_emitting(true)
	
