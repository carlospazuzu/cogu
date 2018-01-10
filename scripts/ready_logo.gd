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
	
