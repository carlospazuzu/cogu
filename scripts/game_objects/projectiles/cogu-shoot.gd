extends KinematicBody2D

const SPEED = 800
var direction

func _ready():
	set_fixed_process(true)
	
func set_direction(direction):
	self.direction = direction
	
func _fixed_process(delta):
	move(Vector2(SPEED * delta * direction, 0))
	get_node("AnimatedSprite").set_flip_h(true if direction == -1 else false)
	
	if is_colliding():
		get_parent().get_child(1).active_bullets -= 1
		free()
