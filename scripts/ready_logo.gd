extends Label

var visible = true

func _ready():
	pass

func _on_Timer_timeout():
	if visible:
		set_hidden(false)
	else:
		set_hidden(true)
	
	visible = not visible
	

func _on_Timeout_Timer_timeout():
	get_parent().get_node("cogu travel").set_fixed_process(true)
	queue_free()
