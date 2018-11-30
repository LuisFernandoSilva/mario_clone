extends CanvasLayer

var nextPath

func fadeTo(path): #funcao que vai fazer o efeito de animaçao da scen de transiçao
	nextPath = path
	get_node("anim").play("fade")
	
func changeScene():
	if nextPath != null:
		get_tree().change_scene(nextPath) #pega o root atual da cena e muda pra proxima cena
	
 

	
