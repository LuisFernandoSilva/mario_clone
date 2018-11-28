extends Node

onready var char = get_node("character")
onready var deadCamera = get_node("deadCamera")


func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

func changeCamera():
	deadCamera.set_global_pos(char.get_node("camera").get_global_pos()) #seta a posiçao da camera com a camera de morte
	deadCamera.make_current() #set a camera de morte como a principal
	

func _on_character_dead():
	changeCamera()
