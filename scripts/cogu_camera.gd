extends Camera2D

onready var player = get_parent().get_node("player")

func _ready():
	pass
	
func _fixed_process(delta):
	var current_x = player.get_pos().x - 389
	current_x = clamp(current_x, 0, 1000)
	set_pos(Vector2(current_x, 0))
	print(get_pos())
