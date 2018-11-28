extends KinematicBody2D

var direction = 1
var speed = 0.3
var live = true

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	#chama o pai e pega o unit offset e faz o calculo com o delta pra saber qual e o atual
	var new_offset = get_parent().get_unit_offset() + delta *direction * speed
	# offset vai de 0 a 1
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.99999)
		get_node("sprite").set_flip_h(false) #esta olhando pra esquerda
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
		get_node("sprite").set_flip_h(true)
	else:
		get_parent().set_unit_offset(new_offset)
		
func smash():
	if not live: return 
	live = false
	get_node("anim").stop()
	get_node("sprite").set_texture(load("res://assets/inimigo/slimeDead.png"))
	get_node("sprite").set_offset(Vector2(0,8))
	get_node("shape").queue_free()
	set_fixed_process(false)
	
	
