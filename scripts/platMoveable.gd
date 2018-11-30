extends KinematicBody2D

var direction = 1
var speed = 0.2


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	#chama o pai e pega o unit offset e faz o calculo com o delta pra saber qual e o atual
	var new_offset = get_parent().get_unit_offset() + delta *direction * speed
	# offset vai de 0 a 1
	if direction == 1 and new_offset >= 0.99999:
		direction = -1
		get_parent().set_unit_offset(0.99999)
		
	elif direction == -1 and new_offset <= 0:
		direction = 1
		get_parent().set_unit_offset(0)
		
	else:
		get_parent().set_unit_offset(new_offset)
		
