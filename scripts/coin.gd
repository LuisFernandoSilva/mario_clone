extends Area2D




func _on_coin_body_enter( body ):
	get_node("anim").play("colectCoin")
	get_node("shape").queue_free()
	yield(get_node("anim"), "finished") #espere ate acontecer algo
	queue_free()
