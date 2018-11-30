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
	get_node("spawnTimer").set_wait_time(1.5)
	get_node("spawnTimer").start()


func _on_spawnTimer_timeout():
	reborn()

func reborn():
	char.set_pos(get_node("spawnPoint").get_pos()) #pega a posiçao do spawn point e reinicia o personagem
	char.rebornCharacter() #chama funcao do script character

func _on_character_end():
	changeCamera() 
	#atualmente fazendo o respawn porem pode ser feito outra fase
	get_node("spawnTimer").set_wait_time(3)
	get_node("spawnTimer").start()
